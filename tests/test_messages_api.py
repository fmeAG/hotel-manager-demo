from app.models import Room, RoomStatus


def seed_room(db, number="101", category="Single", status=RoomStatus.available):
    room = Room(number=number, category=category, status=status)
    db.add(room)
    db.commit()
    db.refresh(room)
    return room


def test_create_message(client, db):
    room = seed_room(db)
    res = client.post(
        "/api/messages",
        json={"room_id": room.id, "sender": "Reception", "content": "Welcome!"},
    )
    assert res.status_code == 201
    body = res.json()
    assert body["room_id"] == room.id
    assert body["content"] == "Welcome!"
    assert body["status"] == "sent"


def test_create_message_invalid_room(client):
    res = client.post(
        "/api/messages",
        json={"room_id": 999, "sender": "Reception", "content": "Hello"},
    )
    assert res.status_code == 404


def test_list_messages(client, db):
    room = seed_room(db)
    client.post("/api/messages", json={"room_id": room.id, "sender": "Reception", "content": "Hi"})
    res = client.get("/api/messages")
    assert res.status_code == 200
    assert len(res.json()) == 1


def test_list_messages_filtered_by_room(client, db):
    room1 = seed_room(db, "101")
    room2 = seed_room(db, "102")
    client.post("/api/messages", json={"room_id": room1.id, "sender": "Reception", "content": "For 1"})
    client.post("/api/messages", json={"room_id": room2.id, "sender": "Reception", "content": "For 2"})
    res = client.get(f"/api/messages?room_id={room1.id}")
    assert res.status_code == 200
    body = res.json()
    assert len(body) == 1
    assert body[0]["room_id"] == room1.id


def test_get_message_by_id(client, db):
    room = seed_room(db)
    create_res = client.post("/api/messages", json={"room_id": room.id, "sender": "Reception", "content": "Hi"})
    message_id = create_res.json()["id"]
    res = client.get(f"/api/messages/{message_id}")
    assert res.status_code == 200
    assert res.json()["id"] == message_id


def test_get_message_not_found(client):
    res = client.get("/api/messages/999")
    assert res.status_code == 404


def test_patch_message_status(client, db):
    room = seed_room(db)
    create_res = client.post("/api/messages", json={"room_id": room.id, "sender": "Reception", "content": "Hi"})
    message_id = create_res.json()["id"]
    res = client.patch(f"/api/messages/{message_id}/status", json={"status": "delivered"})
    assert res.status_code == 200
    assert res.json()["status"] == "delivered"


def test_patch_message_status_invalid_transition(client, db):
    room = seed_room(db)
    create_res = client.post("/api/messages", json={"room_id": room.id, "sender": "Reception", "content": "Hi"})
    message_id = create_res.json()["id"]
    res = client.patch(f"/api/messages/{message_id}/status", json={"status": "read"})
    assert res.status_code == 409


def test_guest_view_message_flow(client, db):
    """Pins the request sequence guest_messages.js relies on (Decision 008)."""
    room = seed_room(db)

    reception_msg = client.post(
        "/api/messages",
        json={"room_id": room.id, "sender": "Reception", "content": "Welcome!"},
    ).json()

    client.patch(f"/api/messages/{reception_msg['id']}/status", json={"status": "delivered"})

    guest_msg = client.post(
        "/api/messages",
        json={"room_id": room.id, "sender": f"Guest (Room {room.number})", "content": "Thanks!"},
    ).json()
    assert guest_msg["status"] == "sent"

    res = client.get(f"/api/messages?room_id={room.id}")
    by_id = {m["id"]: m for m in res.json()}
    assert by_id[reception_msg["id"]]["status"] == "delivered"
    assert by_id[guest_msg["id"]]["status"] == "sent"

    read_res = client.patch(f"/api/messages/{reception_msg['id']}/status", json={"status": "read"})
    assert read_res.status_code == 200
    assert read_res.json()["status"] == "read"
