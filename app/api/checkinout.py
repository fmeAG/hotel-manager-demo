from __future__ import annotations
from datetime import date
from typing import Optional
from fastapi import APIRouter, Depends
from pydantic import BaseModel
from sqlalchemy.orm import Session
from app.database import get_db
from app.services import checkinout_service

router = APIRouter(prefix="/api/guests", tags=["check-in/out"])


class GuestResponse(BaseModel):
    id: int
    first_name: str
    last_name: str
    room_id: Optional[int]
    check_in_date: Optional[date]
    check_out_date: Optional[date]

    model_config = {"from_attributes": True}


class CheckInRequest(BaseModel):
    room_id: int


@router.post("/{guest_id}/checkin", response_model=GuestResponse)
def check_in(guest_id: int, body: CheckInRequest, db: Session = Depends(get_db)):
    return checkinout_service.check_in(db, guest_id, body.room_id)


@router.post("/{guest_id}/checkout", response_model=GuestResponse)
def check_out(guest_id: int, db: Session = Depends(get_db)):
    return checkinout_service.check_out(db, guest_id)
