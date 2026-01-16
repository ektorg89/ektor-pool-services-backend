# Ektor Pool Services Backend API — Roadmap

This roadmap describes the next engineering milestones for evolving the backend into a more production-ready service while keeping a clean modular architecture and strong test coverage.

---

## Current Status (Completed)

### Core Platform
- FastAPI service running via Docker Compose
- MySQL 8 database container with schema bootstrap + demo seeds
- SQLAlchemy ORM models and persistence layer
- Modular v1 router layout

### Authentication & Authorization
- OAuth2 password flow (`/api/v1/auth/token`)
- JWT access token issuance and validation
- Role-Based Access Control (RBAC)
  - `admin` vs `staff`
  - Admin-only operations enforced via dependency injection

### Domain Modules
- Customers: CRUD + validation + correct HTTP status behavior
- Properties: CRUD + ownership enforcement
- Invoices: list/detail/create + validation rules
- Payments: create/list + business rules
- Reports: Customer statement report endpoint

### Engineering Quality
- Standardized error responses
- Request tracing via `request_id`
- Integration tests via pytest
- GitHub Actions CI pipeline (runs Docker Compose + pytest)

---

## Phase 1 — Documentation & Dev Experience (Immediate)

### 1.1 Improve Developer Documentation
- Add a complete Quickstart (2-command setup)
- Document seed/admin bootstrap behavior
- Add examples for:
  - Registering a user
  - Login + token usage
  - Admin vs staff behavior

### 1.2 OpenAPI / Docs Quality
- Ensure endpoint descriptions are clear and consistent
- Confirm expected response models for all endpoints
- Improve parameter documentation for filters and reports

#### Exit Criteria
- README provides complete onboarding for any developer
- Swagger docs are self-explanatory with correct schemas

---

## Phase 2 — Production Hardening

### 2.1 Security Improvements
- Enforce strong password policy (optional but recommended)
- Prevent JWT secret fallback usage in non-dev environments
- Add token expiration configuration via env vars
- Add rate limiting (optional)

### 2.2 Configuration Profiles
- development vs production mode
- Disable docs endpoints in production if desired
- Add structured settings module:
  - `pydantic-settings` or equivalent configuration layer

### 2.3 Observability Enhancements
- Add consistent log fields:
  - `event`, `request_id`, `user_id` (when available)
- Optional request timing middleware expansion
- Add `/health` deep check mode (DB connectivity)

#### Exit Criteria
- Clear separation between dev/prod settings
- Safer default behaviors for production

---

## Phase 3 — Database & Migrations

### 3.1 Alembic Migrations (Optional Upgrade)
- Introduce Alembic for versioned schema management
- Ensure migrations run cleanly in Docker
- Remove schema drift risk from manual SQL edits

### 3.2 Integrity & Constraints
- Confirm all FK constraints exist for:
  - `properties.customer_id`
  - `invoices.customer_id` / `invoices.property_id`
  - `payments.invoice_id`
- Add indexes for frequently filtered columns:
  - `invoices.status`, `invoices.customer_id`, `invoices.property_id`
  - `payments.invoice_id`

#### Exit Criteria
- Schema changes are fully reproducible and versioned

---

## Phase 4 — Advanced API Behavior

### 4.1 Pagination
- Add pagination to list endpoints:
  - customers
  - properties
  - invoices
  - payments
- Standardize query params:
  - `limit`, `offset`
  - or cursor-based pagination

### 4.2 Sorting & Filtering Improvements
- Sorting options:
  - by `created_at` or `invoice_id`
- Add search fields:
  - customers: name/email
  - properties: city/state/label

### 4.3 Invoice Lifecycle Expansion
- Add invoice status transition endpoint:
  - `PATCH /invoices/{id}/status`
- Validate transitions:
  - `draft` → `sent`
  - `sent` → `paid`
  - `sent` → `void`
  - `void` and `paid` remain immutable

#### Exit Criteria
- The API behaves like a scalable business backend with predictable list behavior

---

## Phase 5 — Testing Expansion

### 5.1 Coverage Improvements
- Add negative tests for:
  - auth edge cases
  - invalid tokens
  - expired tokens
- Add tests for:
  - invoice filters
  - payments filters

### 5.2 Test Data Utilities
- Introduce reusable factories/fixtures for:
  - customer
  - property
  - invoice
  - payment

#### Exit Criteria
- Strong test reliability and reduced boilerplate

---

## Phase 6 — Deployment (Real Hosting)

### 6.1 Deploy to a Production Platform
Target options:
- Railway
- Render
- Fly.io
- DigitalOcean

### 6.2 Production Checklist
- Configure env vars:
  - `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`
  - `JWT_SECRET_KEY`
- Enable container health checks
- Confirm startup ordering stability (DB readiness)

#### Exit Criteria
- Stable hosted backend accessible via public URL

---

## Phase 7 — Future Expansion (Optional)

### 7.1 Business Entities Expansion
- Visits module (service visits history)
- Service catalog as editable API resource
- Invoice lines as API resources

### 7.2 Multi-tenant / Real Business Scaling
- Support multiple technicians
- Add organization/company entity
- Add permissions model beyond admin/staff

#### Exit Criteria
- Feature set approaches real-world pool service SaaS functionality

---

## Version Targets (Suggested)

- v1.0.0 Current backend (portfolio deliverable)
- v1.1.0 Documentation polish + pagination
- v1.2.0 Migration support + stronger production defaults
- v2.0.0 Advanced invoice lifecycle + visits/service modules