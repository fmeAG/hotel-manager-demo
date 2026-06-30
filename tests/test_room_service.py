import pytest
from fastapi import HTTPException
from app.models import Room, RoomStatus
from app.services import room_service


def make_room(db, number="101", category="Single", status=RoomStatus.available):
    room = Room(number=number, category=category, status=status)
    db.add(room)
    db.commit()
    db.refresh(room)
    return room


def test_list_rooms_returns_all(db):
    make_room(db, "101")
    make_room(db, "102")
    rooms = room_service.list_rooms(db)
    assert len(rooms) == 2


def test_get_room_not_found(db):
    with pytest.raises(HTTPException) as exc:
        room_service.get_room(db, 999)
    assert exc.value.status_code == 404


def test_change_status_success(db):
    room = make_room(db, status=RoomStatus.available)
    updated = room_service.change_status(db, room.id, RoomStatus.cleaning)
    assert updated.status == RoomStatus.cleaning


def test_change_status_occupied_to_available_rejected(db):
    room = make_room(db, status=RoomStatus.occupied)
    with pytest.raises(HTTPException) as exc:
        room_service.change_status(db, room.id, RoomStatus.available)
    assert exc.value.status_code == 409


def test_change_status_occupied_to_cleaning_allowed(db):
    room = make_room(db, status=RoomStatus.occupied)
    updated = room_service.change_status(db, room.id, RoomStatus.cleaning)
    assert updated.status == RoomStatus.cleaning
