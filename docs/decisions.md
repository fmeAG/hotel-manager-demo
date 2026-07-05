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

---

## Decision 004

Date: 2026-07-02

Context:
The browser UI used per-page inline `<style>` blocks that duplicated nav/table/button rules inconsistently across the three pages (rooms, guests, check-in). Styling had drifted apart and nothing was responsive.

Decision:
Consolidate all UI styling into a single shared vanilla stylesheet `static/css/style.css`, loaded via `<link>` from every page. No CSS framework, no build step, no external font requests (system font stack). Theme is a modern SaaS-admin look with an indigo accent (`#4f46e5`) and CSS custom properties for palette, spacing, radii, and shadows. Tables become horizontally scrollable on small viewports via a `.table-wrap` container instead of restructuring rows into cards.

Consequences:
Single source of truth for styling — a change to the design tokens propagates to every page. Stays consistent with Decision 001 (no frontend tooling). Responsive by default without markup-per-row logic. Adds one static asset that FastAPI's existing `StaticFiles` mount already serves at `/css/style.css`. Status and button classes now follow a documented component vocabulary (`.badge`, `.btn`, `.panel`), so future pages must reuse these classes rather than reintroducing inline styles.

