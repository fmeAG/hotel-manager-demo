from __future__ import annotations
from datetime import date
from typing import Optional
from fastapi import APIRouter, Depends, status
from pydantic import BaseModel
from sqlalchemy.orm import Session
from app.database import get_db
from app.services import guest_service

router = APIRouter(prefix="/api/guests", tags=["guests"])


class GuestResponse(BaseModel):
    id: int
    first_name: str
    last_name: str
    room_id: Optional[int]
    check_in_date: Optional[date]
    check_out_date: Optional[date]

    model_config = {"from_attributes": True}


class GuestCreate(BaseModel):
    first_name: str
    last_name: str


@router.get("", response_model=list[GuestResponse])
def list_guests(db: Session = Depends(get_db)):
    return guest_service.list_guests(db)


@router.post("", response_model=GuestResponse, status_code=status.HTTP_201_CREATED)
def create_guest(body: GuestCreate, db: Session = Depends(get_db)):
    return guest_service.create_guest(db, body.first_name, body.last_name)


@router.get("/{guest_id}", response_model=GuestResponse)
def get_guest(guest_id: int, db: Session = Depends(get_db)):
    return guest_service.get_guest(db, guest_id)


@router.put("/{guest_id}", response_model=GuestResponse)
def update_guest(guest_id: int, body: GuestCreate, db: Session = Depends(get_db)):
    return guest_service.update_guest(db, guest_id, body.first_name, body.last_name)


@router.delete("/{guest_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_guest(guest_id: int, db: Session = Depends(get_db)):
    guest_service.delete_guest(db, guest_id)
