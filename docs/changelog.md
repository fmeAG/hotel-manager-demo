# Changelog

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
