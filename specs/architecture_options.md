# Architecture Options for Hotel Messaging

## Purpose

This document describes possible implementation approaches for the hotel messaging feature.

The goal is not to prescribe a single solution but to provide a basis for architectural discussion and evaluation.

---

# Option A: Direct Persistence (Recommended for Initial Implementation)

## Overview

Messages are stored directly in the application's database.

The application exposes REST endpoints for creating and retrieving messages.

All communication is handled synchronously.

---

## Architecture

```text
Frontend
    |
    v
FastAPI
    |
    v
SQLite
```

---

## Advantages

- Simple architecture
- Easy to understand
- Low infrastructure requirements
- Fast implementation
- Easy testing
- Suitable for small systems

---

## Disadvantages

- Limited scalability
- No asynchronous delivery
- No decoupling of communication components

---

## Typical Use Cases

- Small applications
- Internal tools
- First implementation stage
- Proof of concepts

---

# Option B: Message Broker Architecture

## Overview

Messages are not only stored in the database.

A message broker is introduced to distribute messages between components.

Possible technologies:

- Redis
- RabbitMQ

---

## Architecture

```text
Frontend
    |
    v
FastAPI
    |
    +------------------+
    |                  |
    v                  v
SQLite          Message Broker
                     |
                     v
             Message Consumers
```

---

## Advantages

- Supports asynchronous communication
- Better scalability
- Decoupled architecture
- Easier integration of additional services
- Foundation for future notification mechanisms

---

## Disadvantages

- Increased complexity
- Additional infrastructure
- More operational effort
- More difficult debugging
- Additional testing requirements

---

## Typical Use Cases

- Large distributed systems
- Event-driven architectures
- High message volume
- Multi-service environments

---

# Evaluation Criteria

When comparing implementation options, consider:

## Business Requirements

- Current business needs
- Expected growth
- Future roadmap

---

## Technical Complexity

- Implementation effort
- Testing effort
- Operational complexity

---

## Maintainability

- Understandability
- Team expertise
- Long-term support effort

---

## Cost

- Infrastructure requirements
- Operational costs
- Development effort

---

# Recommendation for the Training Scenario

For the training project, Option A is recommended.

Reasons:

- Focus remains on software development practices.
- Architectural complexity does not dominate the workshop.
- Participants can concentrate on:
  - Specification analysis
  - Repository analysis
  - Implementation planning
  - Coding
  - Testing
  - Documentation

Option B should be treated as an architectural discussion topic and possible future evolution of the system.

---

# Discussion Questions

Possible prompts for architectural evaluation:

- Which option best satisfies the current requirements?
- Which option scales better?
- Which option is easier to maintain?
- Which option would you choose for a productive environment?
- At which point would a message broker become beneficial?
