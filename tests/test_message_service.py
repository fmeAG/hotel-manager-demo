import pytest
from fastapi import HTTPException
from app.models import Room, RoomStatus, MessageStatus
from app.services import message_service


def make_room(db, number="101", category="Single", status=RoomStatus.available):
    room = Room(number=number, category=category, status=status)
    db.add(room)
    db.commit()
    db.refresh(room)
    return room


def test_send_message_creates_message_with_sent_status(db):
    room = make_room(db)
    message = message_service.send_message(db, room.id, "Reception", "Welcome!")
    assert message.id is not None
    assert message.room_id == room.id
    assert message.sender == "Reception"
    assert message.content == "Welcome!"
    assert message.status == MessageStatus.sent
    assert message.created_at is not None


def test_send_message_invalid_room_rejected(db):
    with pytest.raises(HTTPException) as exc:
        message_service.send_message(db, 999, "Reception", "Hello")
    assert exc.value.status_code == 404


def test_list_messages_returns_all(db):
    room = make_room(db)
    message_service.send_message(db, room.id, "Reception", "One")
    message_service.send_message(db, room.id, "Reception", "Two")
    messages = message_service.list_messages(db)
    assert len(messages) == 2


def test_list_messages_filtered_by_room(db):
    room1 = make_room(db, "101")
    room2 = make_room(db, "102")
    message_service.send_message(db, room1.id, "Reception", "For room 1")
    message_service.send_message(db, room2.id, "Reception", "For room 2")
    messages = message_service.list_messages(db, room_id=room1.id)
    assert len(messages) == 1
    assert messages[0].room_id == room1.id


def test_get_message_not_found(db):
    with pytest.raises(HTTPException) as exc:
        message_service.get_message(db, 999)
    assert exc.value.status_code == 404


def test_change_status_sent_to_delivered(db):
    room = make_room(db)
    message = message_service.send_message(db, room.id, "Reception", "Hi")
    updated = message_service.change_status(db, message.id, MessageStatus.delivered)
    assert updated.status == MessageStatus.delivered


def test_change_status_delivered_to_read(db):
    room = make_room(db)
    message = message_service.send_message(db, room.id, "Reception", "Hi")
    message_service.change_status(db, message.id, MessageStatus.delivered)
    updated = message_service.change_status(db, message.id, MessageStatus.read)
    assert updated.status == MessageStatus.read


def test_change_status_skip_rejected(db):
    room = make_room(db)
    message = message_service.send_message(db, room.id, "Reception", "Hi")
    with pytest.raises(HTTPException) as exc:
        message_service.change_status(db, message.id, MessageStatus.read)
    assert exc.value.status_code == 409


def test_change_status_backwards_rejected(db):
    room = make_room(db)
    message = message_service.send_message(db, room.id, "Reception", "Hi")
    message_service.change_status(db, message.id, MessageStatus.delivered)
    with pytest.raises(HTTPException) as exc:
        message_service.change_status(db, message.id, MessageStatus.sent)
    assert exc.value.status_code == 409
