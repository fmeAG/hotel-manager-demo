# Documentation Structure

## Purpose

The project documentation serves two goals:

1. Support developers in understanding and extending the system.
2. Provide structured context for AI-assisted development.

Documentation is considered part of the software product and must be maintained together with code changes.

---

# Documentation Layout

docs/
├── overview.md
├── architecture.md
├── api.md
├── decisions.md
├── changelog.md
├── documentation_structure.md
└── chat_gap_analysis.md
specs/
├── basis_spec.md
├── chat_feature_spec.md
└── architecture_options.md

---

# overview.md

## Purpose

Provides a functional overview of the system.

Target audience:

- New developers
- Architects
- Product owners
- AI assistants

## Contents

- System purpose
- Business context
- Major capabilities
- Main workflows
- Scope boundaries

---

# architecture.md

## Purpose

Describes the technical architecture of the solution.

Target audience:

- Developers
- Architects
- AI assistants

## Contents

- Architecture overview
- Component structure
- Layer responsibilities
- Data model overview
- External dependencies
- Architectural constraints

## Update Rules

Must be updated whenever:

- New components are introduced
- Existing architecture changes
- New integrations are added

---

# api.md

## Purpose

Documents externally exposed APIs.

## Contents

- Endpoints
- Request structures
- Response structures
- Status codes
- Example payloads

## Update Rules

Must be updated whenever:

- New endpoints are introduced
- Existing endpoints change
- Request or response models change

---

# decisions.md

## Purpose

Stores important technical decisions.

This file acts as lightweight architecture decision documentation.

## Decision Format

Each decision should contain:

- Date
- Context
- Decision
- Consequences

Example:

```md
## Decision 001

Date: 2026-06-15

Context:
The system requires message persistence.

Decision:
SQLite is used for the initial implementation.

Consequences:
Simple deployment and low operational complexity.
```

## Update Rules

Must be updated whenever:

- Significant architectural decisions are made
- Alternative solutions are evaluated
- Trade-offs are discussed

---

# changelog.md

## Purpose

Tracks functional and technical changes.

## Format

### Added

New functionality.

### Changed

Modified functionality.

### Fixed

Bug fixes.

### Removed

Removed functionality.

## Update Rules

Must be updated after every completed implementation step.

---

# Documentation Principles

## Principle 1

Documentation must describe reality.

Documentation must never describe planned functionality as already implemented.

---

## Principle 2

Documentation must evolve together with the software.

Code changes without documentation updates are considered incomplete.

---

## Principle 3

Documentation should be concise.

Avoid unnecessary text and duplication.

---

## Principle 4

Documentation should support AI-assisted development.

Documentation should be structured in a way that allows AI tools to efficiently consume and reason about the content.

---

# AI-Assisted Documentation Workflow

After completing a feature implementation:

1. Review the implemented changes.
2. Update architecture documentation if required.
3. Update API documentation if required.
4. Record significant decisions.
5. Update the changelog.
6. Verify that documentation matches the current implementation.

Documentation updates are part of the Definition of Done.
