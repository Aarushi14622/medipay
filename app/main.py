"""MediPay Patients service. Synthetic data only."""

from datetime import date

from fastapi import FastAPI, HTTPException, Request, status
from pydantic import BaseModel, ConfigDict, Field

app = FastAPI(title="MediPay Patients", version="0.1.0")

# Added after the Day 7 ZAP scan flagged "X-Content-Type-Options Header Missing".
SECURITY_HEADERS = {
    "X-Content-Type-Options": "nosniff",  # browsers must not guess content types
    "Cache-Control": "no-store",  # patient data must not sit in caches
    "X-Frame-Options": "DENY",  # can't be embedded in another site (clickjacking)
    "Referrer-Policy": "no-referrer",
}


@app.middleware("http")
async def add_security_headers(request: Request, call_next):
    response = await call_next(request)
    response.headers.update(SECURITY_HEADERS)
    return response


class PatientIn(BaseModel):
    model_config = ConfigDict(extra="forbid") 
    full_name: str = Field(min_length=1, max_length=100)
    date_of_birth: date
    member_id: str = Field(pattern=r"^MP-\d{6}$")


class Patient(PatientIn):
    id: int


_patients: dict[int, Patient] = {}


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/patients", status_code=status.HTTP_201_CREATED)
def create_patient(patient: PatientIn) -> Patient:
    new_id = len(_patients) + 1
    record = Patient(id=new_id, **patient.model_dump())
    _patients[new_id] = record
    return record


@app.get("/patients/{patient_id}")
def get_patient(patient_id: int) -> Patient:
    record = _patients.get(patient_id)
    if record is None:
        raise HTTPException(status_code=404, detail="Patient not found")
    return record
