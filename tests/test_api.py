from app.models import Room, RoomStatus


def seed_room(db, number="101", category="Single", status=RoomStatus.available):
    room = Room(number=number, category=category, status=status)
    db.add(room)
    db.commit()
    db.refresh(room)
    return room


def test_list_rooms(client, db):
    seed_room(db)
    res = client.get("/api/rooms")
    assert res.status_code == 200
    assert len(res.json()) == 1


def test_patch_room_status(client, db):
    room = seed_room(db)
    res = client.patch(f"/api/rooms/{room.id}/status", json={"status": "cleaning"})
    assert res.status_code == 200
    assert res.json()["status"] == "cleaning"


def test_create_guest(client):
    res = client.post("/api/guests", json={"first_name": "Hans", "last_name": "Schmidt"})
    assert res.status_code == 201
    assert res.json()["first_name"] == "Hans"


def test_list_guests(client):
    client.post("/api/guests", json={"first_name": "Anna", "last_name": "Müller"})
    res = client.get("/api/guests")
    assert res.status_code == 200
    assert len(res.json()) == 1


def test_update_guest(client):
    create_res = client.post("/api/guests", json={"first_name": "Hans", "last_name": "Schmidt"})
    guest_id = create_res.json()["id"]
    res = client.put(f"/api/guests/{guest_id}", json={"first_name": "Eva", "last_name": "Klein"})
    assert res.status_code == 200
    assert res.json()["first_name"] == "Eva"


def test_delete_guest(client):
    create_res = client.post("/api/guests", json={"first_name": "Hans", "last_name": "Schmidt"})
    guest_id = create_res.json()["id"]
    res = client.delete(f"/api/guests/{guest_id}")
    assert res.status_code == 204


def test_checkin_and_checkout(client, db):
    room = seed_room(db)
    guest_res = client.post("/api/guests", json={"first_name": "Anna", "last_name": "Müller"})
    guest_id = guest_res.json()["id"]

    checkin_res = client.post(f"/api/guests/{guest_id}/checkin", json={"room_id": room.id})
    assert checkin_res.status_code == 200
    assert checkin_res.json()["room_id"] == room.id

    checkout_res = client.post(f"/api/guests/{guest_id}/checkout")
    assert checkout_res.status_code == 200
    assert checkout_res.json()["room_id"] is None
