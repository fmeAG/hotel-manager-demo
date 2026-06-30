# Hotel Management Application - Base Specification

## Purpose

The Hotel Management Application supports hotel reception staff in managing rooms and guests.

The application is intentionally designed as a small but realistic business application for demonstrating AI-assisted software development practices.

The system must provide sufficient complexity for:

- Repository analysis
- Specification-driven development
- Impact analysis
- Feature implementation
- Test generation
- Documentation generation
- Architecture discussions

---

# Business Context

Hotels use the application to manage guest stays.

Reception staff must be able to:

- View room availability
- Manage guests
- Perform check-in and check-out
- Track room occupancy

The application is used by hotel employees only.

No authentication or authorization is required for the initial version.

---

# Functional Requirements

## Room Management

A room contains:

- Room number
- Category
- Occupancy status

Possible room statuses:

- Available
- Occupied
- Cleaning

Reception staff must be able to:

- List rooms
- View room details
- Change room status

---

## Guest Management

A guest contains:

- First name
- Last name
- Assigned room
- Check-in date
- Check-out date

Reception staff must be able to:

- Create guests
- View guests
- Update guests
- Delete guests

---

## Check-In

Reception staff must be able to:

- Assign a room to a guest
- Mark the room as occupied
- Store check-in date

---

## Check-Out

Reception staff must be able to:

- Remove room assignment
- Mark room as available
- Store check-out date

---

# Non-Functional Requirements

## Technology

The application shall use:

- Python
- FastAPI
- SQLite
- Docker Compose

The application shall provide:

- REST API
- Browser-based user interface

---

## Code Quality

The application shall:

- Follow a layered architecture
- Separate API, business logic and persistence
- Include automated tests
- Use meaningful naming conventions

---

# Documentation Requirements

The project must contain structured documentation.

Documentation shall be stored in Markdown format.

Required documentation:

- System overview
- Architecture overview
- API documentation
- Technical decisions
- Change history

Documentation must be maintained together with code changes.

---

# Git Workflow

The repository shall be maintained using Git.

Changes should be documented using:

- Meaningful commit messages
- Change documentation
- Decision documentation

Merge requests are assumed as the standard integration mechanism.

---

# Known Limitations

The following features are intentionally not part of the base system:

- Messaging
- Notifications
- Real-time communication
- Authentication
- Authorization

These features may be introduced through future specifications.
