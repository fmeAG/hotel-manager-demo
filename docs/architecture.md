# Architecture Overview

## Component Structure

```
hotel-management/
├── app/
│   ├── main.py              # FastAPI application entry point
│   ├── database.py          # SQLAlchemy engine and session factory
│   ├── models.py            # ORM models (Room, Guest)
│   ├── seed.py              # Initial room data
│   ├── api/                 # HTTP layer — routers only, no business logic
│   │   ├── rooms.py
│   │   ├── guests.py
│   │   └── checkinout.py
│   ├── services/            # Business logic layer
│   │   ├── room_service.py
│   │   ├── guest_service.py
│   │   └── checkinout_service.py
│   └── repositories/        # Persistence layer — SQLAlchemy queries only
│       ├── room_repository.py
│       └── guest_repository.py
├── static/                  # Browser UI — plain HTML + vanilla JS
│   ├── index.html           # Redirects to rooms.html
│   ├── rooms.html
│   ├── guests.html
│   ├── checkin.html
│   ├── css/
│   │   └── style.css        # Shared UI stylesheet (design tokens + components)
│   └── js/
│       ├── rooms.js
│       ├── guests.js
│       └── checkin.js
└── tests/
```

## Layer Responsibilities

| Layer | Responsibility |
|-------|---------------|
| API (`app/api/`) | HTTP routing, request/response serialization via Pydantic, dependency injection |
| Services (`app/services/`) | Business rules, validation, orchestration across repositories |
| Repositories (`app/repositories/`) | SQLAlchemy queries, no business logic |

## Data Model

### Room

| Field | Type | Notes |
|-------|------|-------|
| id | Integer | Primary key |
| number | String | Unique room number |
| category | String | e.g. Single, Double, Suite |
| status | Enum | available / occupied / cleaning |

### Guest

| Field | Type | Notes |
|-------|------|-------|
| id | Integer | Primary key |
| first_name | String | |
| last_name | String | |
| room_id | Integer FK | Nullable — null means not checked in |
| check_in_date | Date | Nullable |
| check_out_date | Date | Nullable |

## External Dependencies

- **FastAPI** — REST API framework
- **SQLAlchemy** — ORM and query builder
- **SQLite** — Embedded database (file: `hotel.db`)
- **Uvicorn** — ASGI server
- **Pydantic** — Request/response validation

## Architectural Constraints

- No authentication or authorization in the initial version.
- The database URL is configurable via the `DATABASE_URL` environment variable (default: `sqlite:///./hotel.db`).
- Static files are served by FastAPI's `StaticFiles` mount at `/`. API routes (`/api/*`) take priority.
