from __future__ import annotations
from fastapi import HTTPException
from sqlalchemy.orm import Session
from app.models import Message, MessageStatus
from app.repositories import message_repository, room_repository

ALLOWED_TRANSITIONS = {
    MessageStatus.sent: {MessageStatus.delivered},
    MessageStatus.delivered: {MessageStatus.read},
    MessageStatus.read: set(),
}


def send_message(db: Session, room_id: int, sender: str, content: str) -> Message:
    room = room_repository.get_by_id(db, room_id)
    if not room:
        raise HTTPException(status_code=404, detail="Room not found")
    return message_repository.create(db, room_id, sender, content)


def list_messages(db: Session, room_id: int | None = None) -> list[Message]:
    return message_repository.get_all(db, room_id)


def get_message(db: Session, message_id: int) -> Message:
    message = message_repository.get_by_id(db, message_id)
    if not message:
        raise HTTPException(status_code=404, detail="Message not found")
    return message


def change_status(db: Session, message_id: int, status: MessageStatus) -> Message:
    message = get_message(db, message_id)
    if status not in ALLOWED_TRANSITIONS[message.status]:
        raise HTTPException(
            status_code=409,
            detail=f"Cannot change status from {message.status.value} to {status.value}",
        )
    return message_repository.update_status(db, message, status)
