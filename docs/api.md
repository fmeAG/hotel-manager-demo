# API Reference

All endpoints are JSON over HTTP, mounted under `/api`. There is no
authentication; every endpoint is reachable without credentials (see
Scope Boundaries in [overview.md](overview.md)).

---

## Rooms

### `GET /api/rooms`

List all rooms.

Response `200`:

```json
[
  { "id": 1, "number": "101", "category": "Single", "status": "available" }
]
```

### `GET /api/rooms/{room_id}`

Get a single room.

Response `200`: `RoomResponse` (as above).
Response `404`: room does not exist.

### `PATCH /api/rooms/{room_id}/status`

Change a room's status.

Request:

```json
{ "status": "cleaning" }
```

`status` is one of `available`, `occupied`, `cleaning`.

Response `200`: updated `RoomResponse`.
Response `404`: room does not exist.
Response `409`: room is `occupied` and the requested status is not
`cleaning` — an occupied room can only be moved to `cleaning` directly
(Decision 009).

---

## Guests

### `GET /api/guests`

List all guests.

Response `200`:

```json
[
  {
    "id": 1,
    "first_name": "Jörg",
    "last_name": "Müller",
    "room_id": null,
    "check_in_date": null,
    "check_out_date": null
  }
]
```

### `POST /api/guests`

Create a guest.

Request:

```json
{ "first_name": "Jörg", "last_name": "Müller" }
```

Response `201`: created `GuestResponse`. Names are stored as received,
including non-ASCII characters (Decision 007).

### `GET /api/guests/{guest_id}`

Get a single guest.

Response `200`: `GuestResponse`.
Response `404`: guest does not exist.

### `PUT /api/guests/{guest_id}`

Update a guest's first and last name.

Request: same body as `POST /api/guests`.

Response `200`: updated `GuestResponse`.
Response `404`: guest does not exist.

### `DELETE /api/guests/{guest_id}`

Delete a guest.

Response `204`: no content.
Response `404`: guest does not exist.
Response `409`: guest currently has a `room_id` assigned (must be checked out
first).

---

## Check-in / Check-out

### `POST /api/guests/{guest_id}/checkin`

Assign an available room to a guest.

Request:

```json
{ "room_id": 1 }
```

Response `200`: updated `GuestResponse` with `room_id` and `check_in_date`
set. The room's status is set to `occupied`.
Response `404`: guest or room does not exist.
Response `409`: guest already has a room assigned, or the room is not
`available`.

### `POST /api/guests/{guest_id}/checkout`

Remove a guest's room assignment.

Response `200`: updated `GuestResponse` with `room_id` cleared and
`check_out_date` set. The room's status is set to `cleaning`; it cannot be
checked in again until reception marks it `available` after cleaning.
Response `404`: guest does not exist.
Response `409`: guest has no room assigned.

---

## Messages

### `GET /api/messages`

List messages, optionally filtered by room.

Query parameter: `room_id` (optional).

Response `200`:

```json
[
  {
    "id": 1,
    "sender": "Reception",
    "room_id": 1,
    "content": "Welcome!",
    "created_at": "2026-07-20T10:00:00",
    "status": "sent"
  }
]
```

### `POST /api/messages`

Send a message to a room.

Request:

```json
{ "room_id": 1, "sender": "Reception", "content": "Welcome!" }
```

`sender` is a free-text string — there is no authenticated identity behind it
(Decision 006). The reception UI (`messages.html`) sends the staff-entered
value; the guest UI (`guest_messages.html`) always sends the fixed value
`"Guest (Room {number})"` (Decision 008).

Response `201`: created `MessageResponse`, `status` defaults to `sent`.
Response `404`: `room_id` does not reference an existing room.

### `GET /api/messages/{message_id}`

Get a single message.

Response `200`: `MessageResponse`.
Response `404`: message does not exist.

### `PATCH /api/messages/{message_id}/status`

Advance a message's status.

Request:

```json
{ "status": "delivered" }
```

`status` is one of `sent`, `delivered`, `read`.

Response `200`: updated `MessageResponse`.
Response `404`: message does not exist.
Response `409`: the transition is not allowed. Status only moves forward,
one step at a time: `sent → delivered → read` (Decision 006). Skipping a
step (e.g. `sent → read`) or moving backward is rejected.

`GET /api/messages?room_id=` is unauthenticated by design and is the same
endpoint the guest messaging view uses to read its own room's messages
(Decision 008) — there is no separate guest-only endpoint.
