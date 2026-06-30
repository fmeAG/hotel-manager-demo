import enum
from sqlalchemy import Column, Integer, String, Date, ForeignKey, Enum
from sqlalchemy.orm import relationship
from app.database import Base


class RoomStatus(str, enum.Enum):
    available = "available"
    occupied = "occupied"
    cleaning = "cleaning"


class Room(Base):
    __tablename__ = "rooms"

    id = Column(Integer, primary_key=True, index=True)
    number = Column(String, unique=True, nullable=False)
    category = Column(String, nullable=False)
    status = Column(Enum(RoomStatus), default=RoomStatus.available, nullable=False)

    guests = relationship("Guest", back_populates="room")


class Guest(Base):
    __tablename__ = "guests"

    id = Column(Integer, primary_key=True, index=True)
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    room_id = Column(Integer, ForeignKey("rooms.id"), nullable=True)
    check_in_date = Column(Date, nullable=True)
    check_out_date = Column(Date, nullable=True)

    room = relationship("Room", back_populates="guests")
