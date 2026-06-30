# API Documentation

Base URL: `http://localhost:8000`

Interactive docs: `http://localhost:8000/docs`

---

## Rooms

### GET /api/rooms

List all rooms.

**Response 200**
```json
[
  { "id": 1, "number": "101", "category": "Single", "status": "available" }
]
```

### GET /api/rooms/{id}

Get a single room.

**Response 200** — room object  
**Response 404** — room not found

### PATCH /api/rooms/{id}/status

Change room status.

**Request body**
```json
{ "status": "cleaning" }
```

Status values: `available`, `occupied`, `cleaning`

**Business rule:** Occupied rooms can only be changed to `cleaning`.

**Response 200** — updated room  
**Response 404** — room not found  
**Response 409** — invalid status transition

---

## Guests

### GET /api/guests

List all guests.

**Response 200**
```json
[
  {
    "id": 1,
    "first_name": "Anna",
    "last_name": "Müller",
    "room_id": null,
    "check_in_date": null,
    "check_out_date": null
  }
]
```

### POST /api/guests

Create a guest.

**Request body**
```json
{ "first_name": "Anna", "last_name": "Müller" }
```

**Response 201** — created guest

### GET /api/guests/{id}

Get a single guest.

**Response 200** — guest object  
**Response 404** — guest not found

### PUT /api/guests/{id}

Update guest name.

**Request body**
```json
{ "first_name": "Anna", "last_name": "Schmidt" }
```

**Response 200** — updated guest  
**Response 404** — guest not found

### DELETE /api/guests/{id}

Delete a guest.

**Business rule:** Cannot delete a guest who is currently checked in.

**Response 204** — deleted  
**Response 404** — guest not found  
**Response 409** — guest is checked in

---

## Check-in / Check-out

### POST /api/guests/{id}/checkin

Check in a guest to a room.

**Request body**
```json
{ "room_id": 1 }
```

**Business rules:**
- Guest must not already be checked in.
- Room must have status `available`.

**Response 200** — updated guest  
**Response 404** — guest or room not found  
**Response 409** — guest already checked in or room not available

### POST /api/guests/{id}/checkout

Check out a guest.

**Business rules:**
- Guest must be currently checked in.
- Room is set back to `available`.

**Response 200** — updated guest  
**Response 404** — guest not found  
**Response 409** — guest not checked in
