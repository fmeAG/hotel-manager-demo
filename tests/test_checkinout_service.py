import pytest
from fastapi import HTTPException
from app.models import Guest, Room, RoomStatus
from app.services import checkinout_service


def make_room(db, number="101", status=RoomStatus.available):
    room = Room(number=number, category="Single", status=status)
    db.add(room)
    db.commit()
    db.refresh(room)
    return room


def make_guest(db, first="Anna", last="Müller", room_id=None):
    guest = Guest(first_name=first, last_name=last, room_id=room_id)
    db.add(guest)
    db.commit()
    db.refresh(guest)
    return guest


def test_check_in_success(db):
    room = make_room(db)
    guest = make_guest(db)
    result = checkinout_service.check_in(db, guest.id, room.id)
    assert result.room_id == room.id
    assert result.check_in_date is not None
    db.refresh(room)
    assert room.status == RoomStatus.occupied


def test_check_in_unavailable_room(db):
    room = make_room(db, status=RoomStatus.occupied)
    guest = make_guest(db)
    with pytest.raises(HTTPException) as exc:
        checkinout_service.check_in(db, guest.id, room.id)
    assert exc.value.status_code == 409


def test_check_in_already_checked_in(db):
    room1 = make_room(db, "101")
    room2 = make_room(db, "102")
    guest = make_guest(db, room_id=room1.id)
    with pytest.raises(HTTPException) as exc:
        checkinout_service.check_in(db, guest.id, room2.id)
    assert exc.value.status_code == 409


def test_check_out_success(db):
    room = make_room(db, status=RoomStatus.occupied)
    guest = make_guest(db, room_id=room.id)
    result = checkinout_service.check_out(db, guest.id)
    assert result.room_id is None
    assert result.check_out_date is not None
    db.refresh(room)
    assert room.status == RoomStatus.available


def test_check_out_not_checked_in(db):
    guest = make_guest(db)
    with pytest.raises(HTTPException) as exc:
        checkinout_service.check_out(db, guest.id)
    assert exc.value.status_code == 409
