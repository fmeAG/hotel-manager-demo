from fastapi import HTTPException
from sqlalchemy.orm import Session
from app.models import Guest
from app.repositories import guest_repository


def list_guests(db: Session) -> list[Guest]:
    return guest_repository.get_all(db)


def get_guest(db: Session, guest_id: int) -> Guest:
    guest = guest_repository.get_by_id(db, guest_id)
    if not guest:
        raise HTTPException(status_code=404, detail="Guest not found")
    return guest


def create_guest(db: Session, first_name: str, last_name: str) -> Guest:
    return guest_repository.create(db, first_name, last_name)


def update_guest(db: Session, guest_id: int, first_name: str, last_name: str) -> Guest:
    guest = get_guest(db, guest_id)
    return guest_repository.update(db, guest, first_name, last_name)


def delete_guest(db: Session, guest_id: int) -> None:
    guest = get_guest(db, guest_id)
    if guest.room_id is not None:
        raise HTTPException(
            status_code=409,
            detail="Cannot delete a guest who is currently checked in",
        )
    guest_repository.delete(db, guest)
