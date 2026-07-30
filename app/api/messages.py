from __future__ import annotations
from datetime import datetime
from typing import Optional
from fastapi import APIRouter, Depends, status
from pydantic import BaseModel
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import MessageStatus
from app.services import message_service

router = APIRouter(prefix="/api/messages", tags=["messages"])


class MessageResponse(BaseModel):
    id: int
    sender: str
    room_id: int
    content: str
    created_at: datetime
    status: MessageStatus

    model_config = {"from_attributes": True}


class MessageCreate(BaseModel):
    room_id: int
    sender: str
    content: str


class StatusUpdate(BaseModel):
    status: MessageStatus


@router.get("", response_model=list[MessageResponse])
def list_messages(room_id: Optional[int] = None, db: Session = Depends(get_db)):
    return message_service.list_messages(db, room_id)


@router.post("", response_model=MessageResponse, status_code=status.HTTP_201_CREATED)
def create_message(body: MessageCreate, db: Session = Depends(get_db)):
    return message_service.send_message(db, body.room_id, body.sender, body.content)


@router.get("/{message_id}", response_model=MessageResponse)
def get_message(message_id: int, db: Session = Depends(get_db)):
    return message_service.get_message(db, message_id)


@router.patch("/{message_id}/status", response_model=MessageResponse)
def change_status(message_id: int, body: StatusUpdate, db: Session = Depends(get_db)):
    return message_service.change_status(db, message_id, body.status)
