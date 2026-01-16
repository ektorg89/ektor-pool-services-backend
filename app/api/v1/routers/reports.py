from decimal import Decimal
from datetime import date

from fastapi import APIRouter, Depends, HTTPException, Path, Query
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.models.models import Customer, Invoice
from app.schemas.schemas import CustomerStatementOut, StatementItem

router = APIRouter(prefix="/reports", tags=["reports"])

@router.get("/customers/{customer_id}/statement", response_model=CustomerStatementOut)
def customer_statement(
    customer_id: int = Path(..., ge=1, description="Customer ID (>= 1)"),
    from_: date = Query(..., alias="from", description="Start date (YYYY-MM-DD)"),
    to: date = Query(..., description="End date (YYYY-MM-DD)"),
    db: Session = Depends(get_db),
):
    if from_ > to:
        raise HTTPException(status_code=400, detail="'from' must be <= 'to'")

    exists = db.query(Customer.customer_id).filter(Customer.customer_id == customer_id).first()
    if exists is None:
        raise HTTPException(status_code=404, detail="Customer not found")

    invoices = (
        db.query(Invoice)
        .filter(Invoice.customer_id == customer_id)
        .filter(Invoice.issued_date >= from_)
        .filter(Invoice.issued_date <= to)
        .order_by(Invoice.issued_date.asc(), Invoice.invoice_id.asc())
        .all()
    )

    total = sum((inv.total for inv in invoices), Decimal("0.00"))

    items = [
        StatementItem(
            invoice_id=inv.invoice_id,
            issued_date=inv.issued_date,
            status=inv.status,
            total=inv.total,
        )
        for inv in invoices
    ]

    return CustomerStatementOut(
        customer_id=customer_id,
        from_date=from_,
        to_date=to,
        total=total,
        items=items,
    )
