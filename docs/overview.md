# System Overview

## Purpose

The Hotel Management Application supports hotel reception staff in managing rooms and guests.

## Business Context

Hotels use the application to manage guest stays. Reception staff can view room availability, manage guests, and perform check-in and check-out.

## Major Capabilities

- **Room Management** — List rooms, view details, change room status (available / occupied / cleaning)
- **Guest Management** — Create, view, update, and delete guests
- **Check-in** — Assign an available room to a guest and mark the room as occupied
- **Check-out** — Remove the room assignment and mark the room as available
- **Messaging** — Reception can send a message to a room, list and filter messages by room, and view/advance message status (sent / delivered / read). The separated **Guest Chat** entry in the persistent top navigation opens a room selector; guests can then view and reply to that room's messages via the unauthenticated `/guest_messages.html?room_id=` URL. Message delivery to the guest is tracked automatically, and "read" is a guest-confirmed action.

## Main Workflows

### Check-in

1. Reception selects a guest without a room assignment.
2. Reception selects an available room.
3. System assigns the room to the guest, marks the room as occupied, and records the check-in date.

### Check-out

1. Reception selects a guest who is currently checked in.
2. System removes the room assignment, marks the room as available, and records the check-out date.

## Scope Boundaries

Not in scope for the initial version:

- Authentication / Authorization
- Push notifications
- Real-time communication
