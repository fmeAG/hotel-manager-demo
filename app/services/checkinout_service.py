from datetime import date
from fastapi import HTTPException
from sqlalchemy.orm import Session
from app.models import Guest, RoomStatus
from app.repositories import guest_repository, room_repository


def check_in(db: Session, guest_id: int, room_id: int) -> Guest:
    guest = guest_repository.get_by_id(db, guest_id)
    if not guest:
        raise HTTPException(status_code=404, detail="Guest not found")
    if guest.room_id is not None:
        raise HTTPException(status_code=409, detail="Guest is already checked in")

    room = room_repository.get_by_id(db, room_id)
    if not room:
        raise HTTPException(status_code=404, detail="Room not found")
    if room.status != RoomStatus.available:
        raise HTTPException(status_code=409, detail="Room is not available")

    room_repository.update_status(db, room, RoomStatus.occupied)
    return guest_repository.assign_room(db, guest, room_id, date.today())


def check_out(db: Session, guest_id: int) -> Guest:
    guest = guest_repository.get_by_id(db, guest_id)
    if not guest:
        raise HTTPException(status_code=404, detail="Guest not found")
    if guest.room_id is None:
        raise HTTPException(status_code=409, detail="Guest is not checked in")

    room = room_repository.get_by_id(db, guest.room_id)
    room_repository.update_status(db, room, RoomStatus.available)
    return guest_repository.remove_room(db, guest, date.today())
