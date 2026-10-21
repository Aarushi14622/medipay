"""MediPay Patients service. Synthetic data only."""

from datetime import date

from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel, ConfigDict, Field

app = FastAPI(title="MediPay Patients", version="0.1.0")


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
