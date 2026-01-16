# Ektor Pool Services Backend API (FastAPI + MySQL + Docker)

Production-style REST API backend built with **FastAPI**, **SQLAlchemy**, and **MySQL 8**, running via **Docker Compose** and validated with a full **pytest** integration test suite.

This project is structured as a modular backend service with:
- JWT Authentication (OAuth2 password flow)
- Role-Based Access Control (RBAC)
- Domain endpoints for Customers, Properties, Invoices, Payments
- Reporting endpoints (customer statements)
- Standardized error responses + request tracing (`request_id`)
- CI pipeline that runs tests using Docker Compose

---

## Quickstart

```bash
docker compose up -d --build
docker compose exec api python -m pytest -q
```
---

## 1) Architecture Overview

### Runtime Components
- **API Service** (`FastAPI + Uvicorn`)
- **Database Service** (`MySQL 8.0`)

### High-Level Layers
- **Router Layer** (`app/api/v1/routers`)
  - HTTP request/response handling
  - RBAC dependencies enforcement
  - Request validation via Pydantic
- **Persistence Layer** (`SQLAlchemy ORM`)
  - Data access via `Session`
  - Commit/rollback handling for writes
- **Core Utilities**
  - JWT encode/decode
  - password hashing/verification
  - exception handlers (standard error shape)
  - structured logging + request_id middleware

---

## 2) Project Structure

```txt
app/
  api/
    app.py                  # FastAPI app bootstrap + middleware + router mounting
    v1/
      api.py                # v1 router composition (protected_router pattern)
      routers/
        auth.py             # register/login/me + RBAC dependency
        customers.py        # CRUD Customers
        properties.py       # CRUD Properties
        invoices.py         # list/detail/create invoices
        payments.py         # list/create payments + rules
        reports.py          # customer statement report
  core/
    handlers.py             # standard error handling + request id middleware
    logging.py              # logging config (json-like logs)
    security.py             # JWT + password hashing
  db/
    session.py              # SQLAlchemy SessionLocal + get_db()
  models/
    models.py               # SQLAlchemy ORM models
  schemas/
    schemas.py              # Pydantic schemas (customers/properties/invoices/payments/reports)
    auth.py                 # Pydantic schemas (auth responses)
  tests/
    conftest.py
    test_*.py               # integration tests
sql/
  init/
    01_schema.sql           # schema bootstrap
    02_seeds.sql            # seed/demo data
docker-compose.yml
Dockerfile
```
---

## 3) Authentication & RBAC

### Token Flow

- OAuth2PasswordBearer token URL:

    - POST /api/v1/auth/token

- Access tokens are JWT with:

    - sub = user_id

    - iat, exp

### Roles

- admin

- staff

### Default Role Behavior

- POST /api/v1/auth/register creates users with role = staff by default.

- Admin-only operations are protected via:

    - Depends(require_roles("admin"))

### Protected Router Model

All business endpoints run under:

    - protected_router = APIRouter(dependencies=[Depends(get_current_user)])

### Meaning:
 - All endpoints under protected router require a valid JWT
 - Then specific writes require role checks (admin)

 ---

# 4) API Endpoints (Contract)

### Base URL:

- Local: http://localhost:8000

- Versioned: /api/v1

### Health

- GET /health

    - Unauthenticated

    - Returns service status and version

### Auth

- POST /api/v1/auth/register

    - Body: {username, email, password}

    - Creates a new user (default role staff)

    - Returns created user

- POST /api/v1/auth/token

    - Form-encoded:

        - username

        - password

    - Returns JWT access token

- GET /api/v1/auth/me

    - Requires Bearer token

    - Returns current authenticated user

### Customers

- GET /api/v1/customers

    - Requires JWT

    - Returns list (limit 50, sorted desc)

- POST /api/v1/customers

    - Requires JWT + role=admin

    - Creates customer

- GET /api/v1/customers/{customer_id}

    - Requires JWT

    - Returns customer or 404

- PATCH /api/v1/customers/{customer_id}

    - Requires JWT + role=admin

    - Partial update

    - Rejects empty patch with 400

- PUT /api/v1/customers/{customer_id}

    - Requires JWT + role=admin

    - Full replacement

- DELETE /api/v1/customers/{customer_id}

    - Requires JWT + role=admin

    - 204 on success

### Properties

- GET /api/v1/properties

- POST /api/v1/properties (admin-only)

- GET /api/v1/properties/{property_id}

- PATCH /api/v1/properties/{property_id} (admin-only)

- PUT /api/v1/properties/{property_id} (admin-only)

- DELETE /api/v1/properties/{property_id} (admin-only)

Ownership rules enforced for customer/property relationships.

### Invoices

- GET /api/v1/invoices

    - Supports optional filters:

        - status

        - customer_id

        - property_id

        - from_date

        - to_date

- GET /api/v1/invoices/{invoice_id}

- POST /api/v1/invoices

    - Validations:

        - customer exists

        - property exists

        - property belongs to customer

        - period_start <= period_end

        - issued_date <= due_date (when due_date provided)

        - total == subtotal + tax

    - Status allowed:

        - draft | sent | paid | void

### Payments

- GET /api/v1/payments

    - Supports filter: invoice_id (optional)

- POST /api/v1/payments

    - Business rules:

        - invoice must exist

        - cannot pay invoice with status paid (409)

        - cannot pay invoice with status void (400)

        - cannot exceed invoice total (409)

        - duplicate reference per invoice rejected (409)

        - if paid_total == invoice.total => invoice.status becomes paid

        - partial payment keeps invoice as sent

### Reports

- GET /api/v1/reports/customers/{customer_id}/statement?from=YYYY-MM-DD&to=YYYY-MM-DD

    - Requires JWT

    - Returns:

        - invoice list

        - totals for period

    - Validations:

        - from <= to

        - customer must exist

---

## 5) Data Model (Core Tables)

Core application tables used by the API:

- users

    - user_id (PK)

    - username (unique)

    - email (unique)

    - hashed_password

    - role

    - is_active

- customers

    - customer_id (PK)

    - first_name

    - last_name

    - optional phone/email

- properties

    - property_id (PK)

    - customer_id

    - label + address fields

- invoices

    - invoice_id (PK)

    - customer_id

    - property_id

    - date range + totals + status

- payments

    - payment_id (PK)

    - invoice_id

    - amount/date/method/reference
    
---

## 6) Standard Error Response Model

The API uses consistent structured error output.

Example format:

```{
  "code": "REQUEST_VALIDATION_ERROR",
  "message": "Invalid request",
  "details": {
    "errors": [
      {
        "loc": ["body", "customer_id"],
        "msg": "Input should be less than or equal to 100",
        "type": "less_than_equal"
      }
    ],
    "request_id": "uuid"
  },
  "timestamp": "2026-01-16T00:00:00Z"
}
```
Errors are produced for:

- validation failures (422)

- domain missing resources (404)

- integrity conflicts (409)

- RBAC denial (403)
   
---

## 7) Running Locally (Docker)
Start
```text
docker compose up -d --build
```
Run tests
```text
docker compose exec api python -m pytest -q
```
Inspect routes (debug)
```text
docker compose exec api python -c "from app.api.app import app; print('\n'.join(sorted([f'{r.methods} {r.path}' for r in app.router.routes if hasattr(r,'methods')])))"
```

---

## 8) Environment Variables

### API

- APP_VERSION

- JWT_SECRET_KEY

### Optional Admin Bootstrap (first admin user auto-create)

- BOOTSTRAP_ADMIN_USERNAME

- BOOTSTRAP_ADMIN_EMAIL

- BOOTSTRAP_ADMIN_PASSWORD

If set and no admin exists, the API creates the initial admin on startup.

---

## 9) CI (Continuous Integration)

CI is configured to:

- build containers with Docker Compose

- run pytest inside API container

- validate backend behavior on push/PR

---

## 10) Deliverable Classification (Portfolio/Engineering)

This backend is deliverable as a:

- Portfolio-grade backend service

- REST API + MySQL System

- Auth + RBAC + Business Rules Implementation

- Dockerized Integration-Tested Backend

- It demonstrates practical backend engineering workflows:

- DB schema design + seeds

- validations + integrity handling

- auth, roles, access control

- integration testing + CI automation

