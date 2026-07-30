from datetime import date
import unittest

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from app.database import Base
from app.models import Guest, Room, RoomStatus
from app.services.checkinout_service import check_out


class CheckOutServiceTests(unittest.TestCase):
    def setUp(self):
        self.engine = create_engine("sqlite://")
        Base.metadata.create_all(self.engine)
        self.session = sessionmaker(bind=self.engine)()

        self.room = Room(
            number="test-101",
            category="Single",
            status=RoomStatus.occupied,
        )
        self.session.add(self.room)
        self.session.commit()

        self.guest = Guest(
            first_name="Test",
            last_name="Guest",
            room_id=self.room.id,
            check_in_date=date.today(),
        )
        self.session.add(self.guest)
        self.session.commit()

    def tearDown(self):
        self.session.close()
        Base.metadata.drop_all(self.engine)
        self.engine.dispose()

    def test_checkout_moves_room_to_cleaning(self):
        checked_out_guest = check_out(self.session, self.guest.id)
        self.session.refresh(self.room)

        self.assertIsNone(checked_out_guest.room_id)
        self.assertEqual(self.room.status, RoomStatus.cleaning)


if __name__ == "__main__":
    unittest.main()
