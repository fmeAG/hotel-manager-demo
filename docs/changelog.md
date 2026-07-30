# Changelog

## [1.4.0] - 2026-07-20

### Added

- Guest-facing message view: `static/guest_messages.html` + `static/js/guest_messages.js`, reached via an unauthenticated `/guest_messages.html?room_id=` link (no login, consistent with the project's no-auth scope)
- Guests can view and send messages for their own room, not just view them (deliberate scope widening beyond the original spec wording — see Decision 008)
- Automatic `sent → delivered` status transition when the guest view loads a reception-authored message; `→ read` remains an explicit guest action
- "Guest view" link per row in the reception `messages.html` message list
- Integration test `test_guest_view_message_flow` in `tests/test_messages_api.py` pinning the request sequence the guest view depends on

### Changed

- `docs/overview.md` — "Messaging" capability description now covers both reception and guest views; "Guest-facing messaging view" removed from Scope Boundaries

## [1.3.1] - 2026-07-20

### Fixed

- Guest first/last names containing German umlauts (`ä`, `ö`, `ü`, `ß`) were silently stripped to their ASCII-only form on create/update (e.g. `"Jörg"` → `"Jrg"`) due to an unconditional ASCII-only sanitization step in `guest_service`. Non-ASCII characters are now preserved.

## [1.3.0] - 2026-07-20

### Added

- Messaging feature (reception-facing): send a message to a room, list all messages, filter by room, view status (`sent` / `delivered` / `read`), advance status forward
- `Message` model, `message_repository`, `message_service`, `POST/GET /api/messages`, `GET /api/messages/{id}`, `PATCH /api/messages/{id}/status`
- `static/messages.html` + `static/js/messages.js`, linked from all existing pages' nav
- Status badge styles for message status (`badge-sent`, `badge-delivered`, `badge-read`) in `static/css/style.css`
- Unit tests for the message service layer, integration tests for the messages API

### Known limitations

- No guest-facing view yet (spec Story 2) — deferred; `GET /api/messages?room_id=` already supports it without an API change
- `sender` is free text with no authenticated identity behind it, consistent with the project's current no-auth scope

## [1.2.0] - 2026-07-20

### Changed

- Guest editing now opens a proper dialog (native `<dialog>` element) instead of two sequential browser `prompt()` popups

### Added

- Shared dialog/modal styling (`.dialog`, `.dialog-actions`, `.form--stacked`) in `static/css/style.css`, reusing existing design tokens

## [1.1.0] - 2026-07-02

### Changed

- Replaced per-page inline `<style>` blocks with a single shared stylesheet `static/css/style.css`, linked from all three UI pages
- Adopted a cohesive modern SaaS-admin theme: indigo accent (`#4f46e5`), CSS custom properties for palette/spacing/radii/shadows, system font stack
- Made the UI responsive: sticky header, fluid container, horizontally scrollable tables on small viewports
- Unified the component vocabulary across pages (`.btn`, `.btn-primary`, `.btn-secondary`, `.btn-danger`, `.badge`, `.panel`, `.table-wrap`)

### Added

- Semantic `<header>` / `<nav>` site shell with active-page highlighting
- Status badges (`badge-available`, `badge-occupied`, `badge-cleaning`) replacing plain coloured text
- `:focus-visible` rings and AA-contrast colours for keyboard accessibility
- `prefers-reduced-motion` handling



## [1.0.0] - 2026-06-30

### Added

- Room management: list rooms, view details, change status (available / occupied / cleaning)
- Guest management: create, view, update, delete guests
- Check-in: assign an available room to a guest, mark room as occupied, record check-in date
- Check-out: remove room assignment, mark room as available, record check-out date
- REST API with FastAPI (Python)
- SQLite persistence via SQLAlchemy ORM
- Browser UI: multi-page plain HTML/JS (rooms, guests, check-in/check-out)
- Docker Compose deployment configuration
- Unit tests for service layer (22 tests)
- Integration tests for all API endpoints (happy paths)
- Seed data: 5 rooms across Single, Double, and Suite categories
- Documentation: overview, architecture, API reference, decisions, changelog
