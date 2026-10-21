from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)

VALID = {
    "full_name": "Test Patient One",
    "date_of_birth": "1990-01-01",
    "member_id": "MP-000001",
}


def test_health():
    r = client.get("/health")
    assert r.status_code == 200
    assert r.json() == {"status": "ok"}


def test_create_and_get_patient():
    created = client.post("/patients", json=VALID)
    assert created.status_code == 201
    patient_id = created.json()["id"]
    fetched = client.get(f"/patients/{patient_id}")
    assert fetched.status_code == 200
    assert fetched.json()["member_id"] == "MP-000001"


def test_unknown_patient_returns_404():
    assert client.get("/patients/99999").status_code == 404


def test_rejects_unknown_fields():
    r = client.post("/patients", json={**VALID, "is_admin": True})
    assert r.status_code == 422


def test_rejects_bad_member_id():
    r = client.post("/patients", json={**VALID, "member_id": "1234"})
    assert r.status_code == 422
