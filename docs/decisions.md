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
Status: Superseded by [Decision 009](#decision-009).


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

---

## Decision 005

Date: 2026-07-20

Context:
Guest editing used two sequential browser `prompt()` calls, which is not a real UI and only exposes first/last name even though the project had no established pattern for dialogs/modals.

Decision:
Use the native HTML `<dialog>` element (`showModal()` / `close()`) as the project's modal convention, styled with the existing design tokens and component classes (`.panel`-equivalent `.dialog`, `.form`, `.field`, `.btn`) rather than introducing a JS dialog library. Scope stays limited to the fields already covered by `PUT /api/guests/{id}` (first name, last name); room assignment and check-in/out dates remain the responsibility of the dedicated check-in/out page and its endpoints, since changing them also has to keep room status in sync.

Consequences:
No new dependency, consistent with Decision 001 (no frontend tooling/build step). Establishes `<dialog>` + `.dialog`/`.dialog-actions`/`.form--stacked` as the reusable pattern for future modals. Guest editing does not yet cover room/check-in/check-out changes in one place — a future decision is needed if that should be unified.

---

## Decision 006

Date: 2026-07-20

Context:
`specs/chat_feature_spec.md` requires a messaging feature between reception and guests, but leaves database design, API design, sender identity, and read-status handling explicitly open (see `docs/chat_gap_analysis.md`, section 7). No authentication exists in the project, so guest identity cannot be verified. The task for this iteration was scoped to sending, listing/filtering by room, and status display for reception only — guest-facing UI, auth, realtime delivery, push notifications, attachments, and deletion were explicitly excluded.

Decision:
- New `messages` table (`Message` model) following the existing three-layer architecture (`message_repository.py` → `message_service.py` → `app/api/messages.py`), consistent with Decision 002.
- Schema: `id`, `sender` (free-text string, no enum — there is no authenticated user context to derive it from), `room_id` (FK to `rooms.id`, required), `content`, `created_at` (server-set timestamp), `status` (`MessageStatus` enum: `sent` / `delivered` / `read`, default `sent`).
- Delivery mechanism: direct persistence via synchronous REST endpoints (`POST /api/messages`, `GET /api/messages?room_id=`, `GET /api/messages/{id}`, `PATCH /api/messages/{id}/status`), per Option A in `specs/architecture_options.md`. No message broker, no realtime push.
- Status transitions are enforced strictly forward (`sent → delivered → read`) at the service layer, mirroring the room-status transition rule in Decision 003. Skipping a step or moving backward returns `409 Conflict`. Status changes are triggered explicitly (via the reception UI action "Mark delivered/read" in this iteration) rather than automatically, since there is no guest-facing read event yet.
- A guest-facing view and the underlying "who is this guest" question (gap analysis section 7, item 1) are deferred to a follow-up iteration; this iteration only ships the reception-facing `messages.html` (send, list, filter by room, status display/advance). `GET /api/messages?room_id=` already supports a future unauthenticated guest view without an API change.

Consequences:
Consistent with the existing architecture and status-transition precedent, so no new patterns were introduced. The `sender` field being free text means nothing prevents impersonation — acceptable for this training project per the spec's exclusion of auth/authorization, but should be called out as a known limitation. Guest-facing message viewing (spec Story 2) is not yet implemented; `docs/overview.md`'s "Messaging / Notifications" scope note still needs a follow-up update once that ships.

---

## Decision 007

Date: 2026-07-20

Context:
`guest_service.create_guest`/`update_guest` silently ran every first/last name through an ASCII-only sanitization step (`value.encode("ascii", errors="ignore").decode("ascii")`) before persisting it. This dropped German umlauts and ß entirely (e.g. `"Jörg"` → `"Jrg"`, `"Müller"` → `"Mller"`) with no error surfaced to the caller. There is no documented requirement anywhere in `docs/` or `specs/` for ASCII-only guest names — this was undocumented behavior, not an intentional constraint, and it silently corrupted legitimate German names.

Decision:
Remove the ASCII-sanitization step from `guest_service`. Guest names are persisted as received (SQLite/SQLAlchemy `String` columns are UTF-8 safe already; no schema or repository change needed). No replacement validation was added, since none was ever specified — if input restrictions on guest names are needed in the future, they must be defined as an explicit requirement first.

Consequences:
German (and other non-ASCII) names now round-trip correctly through create/update. No migration needed since this only affects data written going forward; any guest rows already corrupted by the old behavior are not backfilled.

---

## Decision 008

Date: 2026-07-20

Context:
Decision 006 deferred the guest-facing message view and the underlying "who is this guest without authentication" question (gap analysis section 7, item 1) to a follow-up iteration. This decision resolves that follow-up. The project has no authentication anywhere (Scope Boundaries, `docs/overview.md`), so any guest-identification scheme has to work without a session or login.

Decision:
- Guest identity is the `room_id` query parameter, unauthenticated — `/guest_messages.html?room_id={id}`. No PIN, code, or other credential is introduced. Anyone with the URL can view and send messages for that room; this is the same no-auth posture as the rest of the application, not a new risk class, but is called out explicitly as a known limitation.
- The persistent top navigation links the guest chat and hotel pages in both directions. Its visually separated Guest Chat link opens a room selector when no `room_id` is provided; selecting a room navigates to the existing query-parameter URL.
- The guest view ships as its own page (`static/guest_messages.html` + `static/js/guest_messages.js`) rather than a role-toggle on the existing reception `messages.html`, matching the project's existing one-page-per-purpose pattern (`rooms.html`, `guests.html`, `checkin.html`, `messages.html`) and avoiding a UI element that would visually imply a real (but nonexistent) permission boundary between roles.
- Scope was widened beyond the original spec wording ("guests can view their room's messages") to let guests also send messages, since a one-way channel was judged less useful than a two-way one for this iteration. This is a deliberate scope decision, not an oversight.
- No backend changes were needed — the guest view is a pure frontend consumer of the existing `GET /api/rooms/{id}`, `GET /api/messages?room_id=`, `POST /api/messages`, and `PATCH /api/messages/{id}/status` endpoints from Decision 006.
- Messages sent from the guest view set `sender` to a fixed, non-editable `"Guest (Room {number})"`, mirroring how Decision 006 already treats `sender` as free text with no authenticated identity behind it.
- Status handling on the guest view: loading the page automatically transitions any `sent` message *not* sent by the guest (i.e. reception-authored) to `delivered`, modeling "the guest's client has received it." Transitioning to `read` remains an explicit action (a "Mark read" button), preserving "read" as a human-confirmed signal rather than an automatic one. A message is classified as guest-authored by checking whether `sender` starts with `"Guest ("` — a string-convention check tied directly to the fixed sender value above, not a new schema field, since introducing a `direction` column was judged out of scope for this iteration (see Rejected alternative below).
- The reception `messages.html` list gained a per-row "Guest view" link (`/guest_messages.html?room_id=...`) so the page is actually reachable without hand-constructing a URL.

Rejected alternative:
A dedicated `direction` (`to_guest` / `from_guest`) column on `Message` was considered for distinguishing guest- from reception-authored messages, instead of the `sender`-prefix check. Rejected for this iteration: it requires a schema change/migration for a distinction the sender-prefix convention already gives for free, and Decision 006 deliberately kept the `messages` schema minimal. Revisit if the `sender` field ever needs to hold something other than a display string (e.g. once real guest identity/auth exists).

Consequences:
Guests can now view and reply to their room's messages via an unauthenticated, bookmarkable URL, with no API or schema changes. `docs/overview.md`'s Scope Boundaries entry "Guest-facing messaging view" is no longer accurate and is updated alongside this decision. The `sender`-prefix convention (`"Guest ("`) is now load-bearing for the auto-delivered logic — renaming or restructuring the fixed sender string requires updating `guest_messages.js`'s `isFromGuest()` check in lockstep. There is no automated test suite for the frontend behavior.


---

## Decision 009

Date: 2026-07-30

Context:
Decision 003 correctly blocked a direct `occupied → available` status update, but its checkout implementation still marked rooms `available`. That bypassed the stated housekeeping requirement and made a checked-out room immediately reusable.

Decision:
Checkout moves the assigned room from `occupied` to `cleaning`. The existing service-level status policy remains the source of truth: check-in accepts only `available` rooms, and reception must explicitly move a cleaned room to `available` before reuse. This supersedes the checkout behavior recorded in Decision 003.

Consequences:
The checkout API contract now exposes the intermediate `cleaning` state. No schema or endpoint changes are required. The checkout service has a regression test covering both the cleared assignment and the required room status.
