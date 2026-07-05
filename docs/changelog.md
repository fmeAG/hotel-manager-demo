# Changelog

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
