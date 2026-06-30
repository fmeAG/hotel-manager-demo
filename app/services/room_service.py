from fastapi import HTTPException
from sqlalchemy.orm import Session
from app.models import Room, RoomStatus
from app.repositories import room_repository


def list_rooms(db: Session) -> list[Room]:
    return room_repository.get_all(db)


def get_room(db: Session, room_id: int) -> Room:
    room = room_repository.get_by_id(db, room_id)
    if not room:
        raise HTTPException(status_code=404, detail="Room not found")
    return room


def change_status(db: Session, room_id: int, status: RoomStatus) -> Room:
    room = get_room(db, room_id)
    if room.status == RoomStatus.occupied and status != RoomStatus.cleaning:
        raise HTTPException(
            status_code=409,
            detail="Occupied rooms can only be changed to cleaning status",
        )
    return room_repository.update_status(db, room, status)
