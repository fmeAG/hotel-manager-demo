from __future__ import annotations
from sqlalchemy.orm import Session
from app.models import Room, RoomStatus


def get_all(db: Session) -> list[Room]:
    return db.query(Room).all()


def get_by_id(db: Session, room_id: int) -> Room | None:
    return db.query(Room).filter(Room.id == room_id).first()


def update_status(db: Session, room: Room, status: RoomStatus) -> Room:
    room.status = status
    db.commit()
    db.refresh(room)
    return room
