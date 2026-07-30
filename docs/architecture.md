# Architecture

## Architecture Overview

The Hotel Management Application is a single FastAPI application serving both
a JSON REST API and static frontend files (plain HTML/JS) from one process.
Persistence is a single SQLite database accessed through SQLAlchemy. There is
no message broker, background worker, or separate frontend build — see
Decision 001 and Decision 002 in [decisions.md](decisions.md).

```text
Browser (static HTML/JS)
        │  fetch()
        ▼
FastAPI app (app/main.py)
        │
        ├── api/            (HTTP layer: routers, request/response models)
        ├── services/        (business logic, validation, status rules)
        └── repositories/     (SQLAlchemy queries)
                │
                ▼
          SQLite (hotel.db)
```

## Component Structure

```text
app/
├── main.py                     # App wiring: router registration, static mount, startup seed
├── database.py                 # Engine, session factory, Base, get_db dependency
├── seed.py                     # One-time room seed data (only if rooms table is empty)
├── models.py                   # SQLAlchemy models: Room, Guest, Message (+ status enums)
├── api/
│   ├── rooms.py                 # /api/rooms
│   ├── guests.py                # /api/guests (CRUD)
│   ├── checkinout.py             # /api/guests/{id}/checkin, /checkout
│   └── messages.py               # /api/messages
├── services/
│   ├── room_service.py
│   ├── guest_service.py
│   ├── checkinout_service.py
│   └── message_service.py
└── repositories/
    ├── room_repository.py
    ├── guest_repository.py
    └── message_repository.py

static/
├── index.html, rooms.html, guests.html, checkin.html   # Reception UI
├── messages.html + js/messages.js                       # Reception messaging UI
├── guest_messages.html + js/guest_messages.js            # Guest messaging UI (unauthenticated)
└── css/style.css                                        # Shared stylesheet (Decision 004)
```

## Layer Responsibilities

- **API layer (`app/api/`)** — FastAPI routers. Defines Pydantic request/response
  models, HTTP methods, paths, and status codes. Delegates all business logic
  to the service layer; contains no direct database access.
- **Service layer (`app/services/`)** — Business rules and validation, e.g.
  room-status transition restrictions (Decision 003), message status
  transitions (Decision 006), guest check-in/out preconditions. Raises
  `HTTPException` for domain errors (404, 409). Depends only on the
  repository layer, not on FastAPI request/response types.
- **Repository layer (`app/repositories/`)** — SQLAlchemy queries and
  persistence only (create, read, update). No business rules.
- **Frontend (`static/`)** — Plain HTML and vanilla JavaScript, one page per
  purpose, calling the JSON API directly via `fetch()`. No build step, no
  framework (Decision 001).

## Data Model Overview

Three entities, all in one SQLite database:

- **Room** — `id`, `number` (unique), `category`, `status`
  (`available` / `occupied` / `cleaning`).
- **Guest** — `id`, `first_name`, `last_name`, `room_id` (nullable FK to
  `rooms.id`), `check_in_date`, `check_out_date`.
- **Message** — `id`, `sender` (free-text string), `room_id` (required FK to
  `rooms.id`), `content`, `created_at` (server-set timestamp), `status`
  (`sent` / `delivered` / `read`, default `sent`). See Decision 006 for the
  rationale behind a free-text `sender` and the status enum.

`Guest.room_id` and `Message.room_id` both reference `Room.id`; there is no
foreign key from `Room` back to a single guest or message (a room can have
zero or more messages; at most one currently-checked-in guest is enforced at
the service layer, not the schema).

## External Dependencies

- **FastAPI** — HTTP framework and routing.
- **SQLAlchemy** — ORM and engine.
- **SQLite** — file-based database (`hotel.db`, path overridable via the
  `DATABASE_URL` environment variable, see `app/database.py`).
- **Docker / Docker Compose** — `Dockerfile` and `docker-compose.yml` exist in
  the repository for running the application in a container.

No message broker, no external API integrations, no authentication provider.

## Architectural Constraints

- No authentication or authorization anywhere in the application (see
  Scope Boundaries in [overview.md](overview.md)). This applies equally to
  reception and guest-facing pages, including the unauthenticated guest
  messaging view (Decision 008).
- Single SQLite database shared by all three entities; no per-entity or
  per-tenant database separation.
- Synchronous, request/response only — no realtime push, polling is the only
  mechanism by which a client observes new data (the guest messaging view
  re-fetches on load and after each action).
- Business rules (room-status transitions, message-status transitions,
  check-in/out preconditions) are enforced in the service layer, not the
  database schema or the API layer.
