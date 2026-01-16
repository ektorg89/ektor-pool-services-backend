import os
from decimal import Decimal
from datetime import date
from typing import Optional

from fastapi import FastAPI, Depends, Query, HTTPException, Path
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError

from app.core.security import hash_password
from app.db.session import get_db, SessionLocal
from app.api.v1.api import api_router
from app.models.models import Customer, Invoice, Property, User
from app.schemas.schemas import (
    CustomerOut,
    CustomerCreate,
    InvoiceOut,
    InvoiceCreate,
    CustomerStatementOut,
    StatementItem,
)
from app.core.handlers import register_exception_handlers, register_request_id_middleware
from app.core.logging import configure_logging


configure_logging()
app = FastAPI(title="Ektor Pool Services API")

register_request_id_middleware(app)
register_exception_handlers(app)

app.include_router(api_router, prefix="/api/v1")

def _bootstrap_admin_if_needed() -> None:
    username = os.getenv("BOOTSTRAP_ADMIN_USERNAME")
    email = os.getenv("BOOTSTRAP_ADMIN_EMAIL")
    password = os.getenv("BOOTSTRAP_ADMIN_PASSWORD")

    if not (username and email and password):
        return

    db = SessionLocal()
    try:
        existing_admin = db.query(User).filter(User.role == "admin").first()
        if existing_admin:
            return

        taken = (
            db.query(User)
            .filter((User.username == username) | (User.email == email))
            .first()
        )
        if taken:
            return

        u = User(
            username=username,
            email=email,
            hashed_password=hash_password(password),
            role="admin",
            is_active=True,
        )
        db.add(u)
        db.commit()
    finally:
        db.close()


@app.on_event("startup")
def _startup() -> None:
    _bootstrap_admin_if_needed()

@app.get("/health")
def health():
    return {
        "status": "ok",
        "version": os.getenv("APP_VERSION", "unknown"),
    }
