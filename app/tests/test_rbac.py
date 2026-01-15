import uuid
from sqlalchemy import text


def _ref(prefix: str) -> str:
    return f"{prefix}-{uuid.uuid4().hex[:10]}"


def _register(client, username: str, email: str, password: str):
    r = client.post(
        "/api/v1/auth/register",
        json={
            "username": username,
            "email": email,
            "password": password,
        },
    )
    assert r.status_code in (201, 409), r.text


def _force_role(db_session, username: str, role: str):
    db_session.execute(
        text("UPDATE users SET role = :role WHERE username = :u"),
        {"role": role, "u": username},
    )
    db_session.commit()


def _token(client, username: str, password: str) -> str:
    r = client.post(
        "/api/v1/auth/token",
        data={"username": username, "password": password},
        headers={"Content-Type": "application/x-www-form-urlencoded"},
    )
    assert r.status_code == 200, r.text
    token = r.json().get("access_token")
    assert token, r.text
    return token


def test_staff_cannot_create_customer(anon_client, db_session):
    u = _ref("staff")
    _register(anon_client, u, f"{u}@example.com", "Password123!")
    _force_role(db_session, u, "staff")

    token = _token(anon_client, u, "Password123!")

    r = anon_client.post(
        "/api/v1/customers",
        json={"first_name": "X", "last_name": "Y"},
        headers={"Authorization": f"Bearer {token}"},
    )
    assert r.status_code == 403, r.text


def test_admin_can_create_customer(anon_client, db_session):
    u = _ref("admin")
    _register(anon_client, u, f"{u}@example.com", "Password123!")
    _force_role(db_session, u, "admin")

    token = _token(anon_client, u, "Password123!")

    r = anon_client.post(
        "/api/v1/customers",
        json={"first_name": "Admin", "last_name": _ref("Cust")},
        headers={"Authorization": f"Bearer {token}"},
    )
    assert r.status_code == 201, r.text
