from fastapi import APIRouter, Depends
from pydantic import BaseModel
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import RoomStatus
from app.services import room_service

router = APIRouter(prefix="/api/rooms", tags=["rooms"])


class RoomResponse(BaseModel):
    id: int
    number: str
    category: str
    status: RoomStatus

    model_config = {"from_attributes": True}


class StatusUpdate(BaseModel):
    status: RoomStatus


@router.get("", response_model=list[RoomResponse])
def list_rooms(db: Session = Depends(get_db)):
    return room_service.list_rooms(db)


@router.get("/{room_id}", response_model=RoomResponse)
def get_room(room_id: int, db: Session = Depends(get_db)):
    return room_service.get_room(db, room_id)


@router.patch("/{room_id}/status", response_model=RoomResponse)
def change_status(room_id: int, body: StatusUpdate, db: Session = Depends(get_db)):
    return room_service.change_status(db, room_id, body.status)
