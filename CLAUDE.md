# Claude Working Instructions

## Purpose

This project is used to demonstrate professional AI-assisted software
development.

Your goal is not only to generate code but to support a complete
development process including:

- Analysis
- Planning
- Architecture discussions
- Implementation
- Testing
- Documentation

Always prioritize maintainability, transparency and traceability over
speed.

------------------------------------------------------------------------

# Project Context

Before making any changes, review the following documentation:

    docs/overview.md
    docs/architecture.md
    docs/api.md
    docs/decisions.md
    docs/changelog.md

Review relevant specifications before implementation:

    specs/*.md

Do not assume undocumented functionality exists.

------------------------------------------------------------------------

# Required Development Workflow

For every feature request, follow the process below.

## Step 1: Understand the Requirement

Review:

- Specification
- Existing implementation
- Documentation

Identify:

- Functional requirements
- Non-functional requirements
- Open questions

Do not start implementation immediately.

------------------------------------------------------------------------

## Step 2: Perform Gap Analysis

Compare:

- Specification
- Source code
- Documentation

Identify:

- Missing functionality
- Missing components
- Required changes
- Risks
- Assumptions

Present findings before implementation.

------------------------------------------------------------------------

## Step 3: Create an Implementation Plan

Create a concise implementation plan.

Include:

- Files to change
- Files to create
- Required tests
- Required documentation updates

Obtain confirmation before major architectural changes.

------------------------------------------------------------------------

## Step 4: Implement Incrementally

Prefer small, focused changes.

Avoid large uncontrolled modifications.

After implementation:

- Verify functionality
- Verify consistency
- Verify architecture alignment

------------------------------------------------------------------------

## Step 5: Create or Update Tests

Functional changes require tests.

Possible test types:

- Unit tests
- Integration tests
- API tests

Do not consider a feature complete without testing.

------------------------------------------------------------------------

## Step 6: Update Documentation

Documentation updates are mandatory.

Review whether updates are required for:

    docs/architecture.md
    docs/api.md
    docs/decisions.md
    docs/changelog.md

Documentation must reflect the actual implementation.

------------------------------------------------------------------------

# Architecture Guidelines

Follow the existing architecture.

Preferred layers:

    API Layer
    Business Logic Layer
    Persistence Layer

Responsibilities must remain separated.

Avoid mixing:

- HTTP concerns
- Business logic
- Database access

------------------------------------------------------------------------

# Decision Documentation

Whenever a meaningful technical decision is made:

Update:

    docs/decisions.md

Document:

- Context
- Decision
- Consequences

------------------------------------------------------------------------

# Changelog Rules

After every completed feature:

Update:

    docs/changelog.md

Include:

- Added
- Changed
- Fixed
- Removed

Only document completed work.

------------------------------------------------------------------------

# Git Support

When requested:

Generate:

- Commit messages
- Pull request descriptions
- Release notes

Use clear and concise language.

Prefer conventional commit style where appropriate.

Example:

    feat(chat): add room messaging support

    Adds message persistence and retrieval for hotel room communication.

------------------------------------------------------------------------

# Quality Standards

Generated code must:

- Be readable
- Be maintainable
- Be testable
- Follow project conventions

Avoid unnecessary complexity.

Prefer simple solutions unless requirements justify additional
complexity.

------------------------------------------------------------------------

# Architecture Evaluation

When multiple implementation options exist:

Do not immediately choose one.

Instead:

1.  Describe alternatives.
2.  Explain trade-offs.
3.  Recommend an option.
4.  Justify the recommendation.

------------------------------------------------------------------------

# Documentation First Mindset

When documentation and implementation differ:

Assume neither is automatically correct.

Analyze both.

Explicitly identify inconsistencies.

Recommend how they should be resolved.

------------------------------------------------------------------------

# Definition of Done

A feature is only complete when:

- Requirements are implemented
- Tests exist
- Documentation is updated
- Changelog is updated
- Major decisions are documented
- No known inconsistencies remain
