from __future__ import annotations
from datetime import date
from sqlalchemy.orm import Session
from app.models import Guest


def get_all(db: Session) -> list[Guest]:
    return db.query(Guest).all()


def get_by_id(db: Session, guest_id: int) -> Guest | None:
    return db.query(Guest).filter(Guest.id == guest_id).first()


def create(db: Session, first_name: str, last_name: str) -> Guest:
    guest = Guest(first_name=first_name, last_name=last_name)
    db.add(guest)
    db.commit()
    db.refresh(guest)
    return guest


def update(db: Session, guest: Guest, first_name: str, last_name: str) -> Guest:
    guest.first_name = first_name
    guest.last_name = last_name
    db.commit()
    db.refresh(guest)
    return guest


def delete(db: Session, guest: Guest) -> None:
    db.delete(guest)
    db.commit()


def assign_room(db: Session, guest: Guest, room_id: int, check_in_date: date) -> Guest:
    guest.room_id = room_id
    guest.check_in_date = check_in_date
    guest.check_out_date = None
    db.commit()
    db.refresh(guest)
    return guest


def remove_room(db: Session, guest: Guest, check_out_date: date) -> Guest:
    guest.room_id = None
    guest.check_out_date = check_out_date
    db.commit()
    db.refresh(guest)
    return guest
