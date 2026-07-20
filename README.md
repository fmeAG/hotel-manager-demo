# Hotel Management Application

A small FastAPI-based hotel management system for reception staff to
manage rooms, guests, and check-in/check-out. See
[docs/overview.md](docs/overview.md) for the full feature overview and
[docs/architecture.md](docs/architecture.md) for the architecture.

## Prerequisites

- Python 3.12+
- pip
- Docker and Docker Compose (optional, for containerized run)

## Run locally

```bash
pip install -r requirements.txt
uvicorn app.main:app --reload
```

The app starts on <http://localhost:8000>. On first start it creates
the SQLite database (`hotel.db` in the project root) and seeds it
with sample rooms.

- Web UI: <http://localhost:8000/>
- API: under `/api/rooms`, `/api/guests` — see
  [docs/api.md](docs/api.md) for the full reference

## Run with Docker Compose

```bash
docker compose up
```

Builds the image from `Dockerfile`, exposes port `8000`, and persists
the SQLite database to `./data/hotel.db` on the host (via the
`data/` volume mount).

## Configuration

- `DATABASE_URL` — SQLAlchemy database URL. Defaults to
  `sqlite:///./hotel.db`. Docker Compose sets it to
  `sqlite:///./data/hotel.db`.

## Run tests

```bash
pip install -r requirements.txt
pytest
```

## Project structure

```
app/
  api/            HTTP routes (FastAPI routers)
  services/       Business logic
  repositories/   Database access (SQLAlchemy)
  models.py       ORM models
  database.py     Engine/session setup
  main.py         App entrypoint, router registration
static/           Browser UI (plain HTML/CSS/JS)
tests/            Pytest suite (service + API tests)
docs/             Overview, architecture, API reference, decisions, changelog
specs/            Feature specifications
```

## Further documentation

- [docs/overview.md](docs/overview.md) — purpose and capabilities
- [docs/architecture.md](docs/architecture.md) — layers and request flow
- [docs/api.md](docs/api.md) — endpoint reference
- [docs/decisions.md](docs/decisions.md) — technical decisions
- [docs/changelog.md](docs/changelog.md) — change history
