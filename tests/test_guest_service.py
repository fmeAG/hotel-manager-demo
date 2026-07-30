import pytest
from fastapi import HTTPException
from app.models import Guest, Room, RoomStatus
from app.services import guest_service


def make_guest(db, first="Anna", last="Müller", room_id=None):
    guest = Guest(first_name=first, last_name=last, room_id=room_id)
    db.add(guest)
    db.commit()
    db.refresh(guest)
    return guest


def test_create_guest(db):
    guest = guest_service.create_guest(db, "Hans", "Schmidt")
    assert guest.id is not None
    assert guest.first_name == "Hans"


def test_create_guest_preserves_german_umlauts(db):
    guest = guest_service.create_guest(db, "Jörg", "Müller")
    assert guest.first_name == "Jörg"
    assert guest.last_name == "Müller"


def test_update_guest(db):
    guest = make_guest(db)
    updated = guest_service.update_guest(db, guest.id, "Eva", "Klein")
    assert updated.first_name == "Eva"
    assert updated.last_name == "Klein"


def test_delete_guest_without_room(db):
    guest = make_guest(db)
    guest_service.delete_guest(db, guest.id)
    assert guest_service.list_guests(db) == []


def test_delete_guest_with_room_rejected(db):
    room = Room(number="101", category="Single", status=RoomStatus.occupied)
    db.add(room)
    db.commit()
    guest = make_guest(db, room_id=room.id)
    with pytest.raises(HTTPException) as exc:
        guest_service.delete_guest(db, guest.id)
    assert exc.value.status_code == 409


def test_get_guest_not_found(db):
    with pytest.raises(HTTPException) as exc:
        guest_service.get_guest(db, 999)
    assert exc.value.status_code == 404
