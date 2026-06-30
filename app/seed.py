from app.database import SessionLocal
from app.models import Room, RoomStatus


def seed():
    db = SessionLocal()
    if db.query(Room).count() > 0:
        db.close()
        return
    rooms = [
        Room(number="101", category="Single", status=RoomStatus.available),
        Room(number="102", category="Single", status=RoomStatus.available),
        Room(number="201", category="Double", status=RoomStatus.available),
        Room(number="202", category="Double", status=RoomStatus.cleaning),
        Room(number="301", category="Suite", status=RoomStatus.available),
    ]
    db.add_all(rooms)
    db.commit()
    db.close()
