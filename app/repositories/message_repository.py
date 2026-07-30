from __future__ import annotations
from sqlalchemy.orm import Session
from app.models import Message, MessageStatus


def create(db: Session, room_id: int, sender: str, content: str) -> Message:
    message = Message(room_id=room_id, sender=sender, content=content)
    db.add(message)
    db.commit()
    db.refresh(message)
    return message


def get_all(db: Session, room_id: int | None = None) -> list[Message]:
    query = db.query(Message)
    if room_id is not None:
        query = query.filter(Message.room_id == room_id)
    return query.all()


def get_by_id(db: Session, message_id: int) -> Message | None:
    return db.query(Message).filter(Message.id == message_id).first()


def update_status(db: Session, message: Message, status: MessageStatus) -> Message:
    message.status = status
    db.commit()
    db.refresh(message)
    return message
