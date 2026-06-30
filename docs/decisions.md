# Technical Decisions

## Decision 001

Date: 2026-06-30

Context:
The base spec requires a browser-based UI without specifying a frontend framework.

Decision:
Plain HTML and vanilla JavaScript are used. Static files are served directly by FastAPI via `StaticFiles`.

Consequences:
Zero frontend build tooling. Simple to deploy and easy to understand. Not suitable for complex UI state management as the application grows.

---

## Decision 002

Date: 2026-06-30

Context:
The spec requires Python, FastAPI, and SQLite. Architecture must separate API, business logic, and persistence.

Decision:
Three-layer architecture: `api/` (FastAPI routers) → `services/` (business logic) → `repositories/` (SQLAlchemy). All layers reside in a single FastAPI application served by one Docker container.

Consequences:
Clear separation of concerns. Simple single-container deployment. Services can be unit-tested independently of HTTP and database.

---

## Decision 003

Date: 2026-06-30

Context:
Occupied rooms cannot be immediately set to available during a checkout — housekeeping must clean the room first.

Decision:
The room status transition from `occupied` directly to `available` is blocked at the service layer. The checkout process sets the room to `available` automatically (implicit housekeeping assumption for simplicity). Manual status changes from `occupied` are restricted to `cleaning` only.

Consequences:
Business rule is enforced at the service layer, not just the API layer. The rule may need revisiting if a real housekeeping workflow is introduced.
