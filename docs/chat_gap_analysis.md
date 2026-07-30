# Gap Analysis: Chat Feature

Source specification: `specs/chat_feature_spec.md`
Comparison basis: current codebase (`app/`, `static/`) and current documentation (`docs/`)
Date: 2026-07-20

Status: **No implementation exists yet.** This document is analysis only; no code was changed.

---

## 1. Anforderungen aus der Spezifikation

Extracted from `specs/chat_feature_spec.md`:

- **Senden von Nachrichten** — Reception kann eine Nachricht erstellen, einen Zielraum auswählen, einen Text eingeben und die Nachricht senden.
- **Anzeigen von Nachrichten (Reception)** — alle Nachrichten ansehen, nach Raum filtern, Nachrichtendetails ansehen.
- **Anzeigen von Nachrichten (Guest)** — Nachrichten ansehen, die dem eigenen Zimmer zugeordnet sind.
- **Nachrichtenhistorie** — Nachrichten werden dauerhaft gespeichert und überstehen einen Neustart der Anwendung.
- **Nachrichtenstatus** — jede Nachricht hat einen Status aus `sent`, `delivered`, `read`; der Status ist beim Anzeigen sichtbar.
- **Nachrichten-Metadaten** — jede Nachricht enthält: eindeutige ID, Sender, Zielraum, Inhalt, Erstellungszeitstempel, aktuellen Status.
- **Qualitätsanforderungen** — bestehende Architektur einhalten (API / Business-Logik / Persistenz getrennt), automatisierte Tests, Dokumentationsupdate, Abwärtskompatibilität.
- **Dokumentationspflicht** — `architecture.md`, `api.md`, `changelog.md` müssen aktualisiert werden; bei Implementierungsentscheidungen zusätzlich `decisions.md`.
- **Akzeptanzkriterien** — Nachrichten können erstellt und abgerufen werden, sind persistent, Status wird gespeichert, Tests vorhanden, Dokumentation aktualisiert.
- **Out of Scope** — Push-Benachrichtigungen, Authentifizierung, Autorisierung, mobile Apps, Echtzeitkommunikation, Anhänge, Löschen von Nachrichten.
- **Explizit offene Fragen** (laut Spec, siehe Abschnitt 7) — Datenbankdesign, API-Design, Frontend-Design, technische Implementierungsdetails, Zustellmechanismus, Read-Status-Handling.

---

## 2. Bereits erfüllt

Nichts. Es existiert derzeit **keinerlei Chat-/Messaging-Code** im Repository:

- Kein `Message`-Modell in [app/models.py](../app/models.py) (nur `Room`, `Guest`).
- Kein `message_repository.py` in [app/repositories/](../app/repositories).
- Kein `message_service.py` in [app/services/](../app/services).
- Kein `app/api/messages.py`, kein Router in [app/main.py](../app/main.py).
- Keine Chat-UI (`static/chat.html`, `static/js/chat.js` existieren nicht; auch keine Nav-Einträge dafür in den bestehenden Seiten).
- Keine Tests zu Nachrichten in [tests/](../tests).

Vorhanden ist lediglich die **Grundlage**, auf der die Funktion aufgesetzt werden kann:

- Etablierte Drei-Schichten-Architektur (`api/` → `services/` → `repositories/`), siehe Decision 002 in [docs/decisions.md](decisions.md) und gespiegelt in `guests`/`rooms`.
- Bestehendes `Room`-Modell mit `id`, das als Fremdschlüssel für den Zielraum einer Nachricht dienen kann.
- Etabliertes UI-Muster: gemeinsames Stylesheet (`static/css/style.css`, Decision 004), Komponentenklassen (`.panel`, `.btn`, `.badge`, `.dialog`), Seitenstruktur mit Header/Nav.
- `specs/architecture_options.md` empfiehlt bereits **Option A (Direct Persistence)** — Nachrichten direkt in SQLite, synchrone REST-Endpunkte, kein Message-Broker — als Grundlage für die Erstimplementierung.

---

## 3. Fehlende Funktionalität

| Bereich | Fehlt |
|---|---|
| Datenmodell | `Message`-Entity (id, sender, room_id, content, created_at, status) |
| Persistenz | Repository-Funktionen: create, list_all, list_by_room, get_by_id, update_status |
| Business-Logik | Service-Funktionen für Senden, Auflisten (mit Filter), Statuswechsel (inkl. Regeln, welche Übergänge erlaubt sind: `sent → delivered → read`) |
| API | Endpunkte zum Erstellen, Auflisten (alle / gefiltert nach Raum), Abrufen einzelner Nachrichtendetails, Setzen/Aktualisieren des Status |
| Guest-Sicht | Ein Weg für Gäste, "ihre" Nachrichten zu sehen — ungeklärt, da keine Authentifizierung existiert (siehe Abschnitt 7) |
| Frontend (Reception) | UI zum Erstellen einer Nachricht (Raum wählen, Text eingeben, senden), Liste aller Nachrichten mit Raumfilter, Detailansicht inkl. Status |
| Frontend (Guest) | Eigene Ansicht/Seite für raumbezogene Nachrichten |
| Tests | Unit-Tests für Service-Schicht, Integrationstests für API-Endpunkte |
| Dokumentation | `docs/architecture.md` und `docs/api.md` aktualisieren — **beide Dateien existieren aktuell noch gar nicht** (siehe Risiken, Abschnitt 8) |
| Decision Log | Eintrag in `docs/decisions.md` für die getroffenen Design-Entscheidungen (DB-Schema, Statusmodell, Zustellmechanismus, Guest-Zugriff) |
| Changelog | Eintrag in `docs/changelog.md` nach Fertigstellung |

---

## 4. Betroffene Dateien

**Neu zu erstellen:**

- `app/models.py` — Erweiterung um `Message`-Model und ggf. `MessageStatus`-Enum (analog zu `RoomStatus`)
- `app/repositories/message_repository.py`
- `app/services/message_service.py`
- `app/api/messages.py`
- `static/chat.html` (oder analog benannt) — Reception-Ansicht
- `static/js/chat.js`
- Optional: separate Guest-Ansicht (z. B. `static/guest_messages.html` + JS), abhängig von Klärung in Abschnitt 7
- `tests/test_message_service.py`
- Erweiterung von `tests/test_api.py` (oder neue `tests/test_messages_api.py`)

**Zu ändern:**

- `app/main.py` — neuen Router registrieren (`app.include_router(messages.router)`)
- `static/index.html`, `static/rooms.html`, `static/guests.html`, `static/checkin.html` — Nav-Eintrag für neue Chat-Seite ergänzen (Konsistenz mit bestehendem Header/Nav-Muster)
- `docs/architecture.md` — **muss neu angelegt werden**, siehe Abschnitt 8
- `docs/api.md` — **muss neu angelegt werden**, siehe Abschnitt 8
- `docs/decisions.md` — neuer Decision-Eintrag (Decision 006)
- `docs/changelog.md` — neuer Versionseintrag nach Fertigstellung

**Nicht betroffen (voraussichtlich):**

- `app/repositories/room_repository.py`, `app/services/room_service.py`, `app/api/rooms.py`, `app/api/checkinout.py` — Nachrichten referenzieren nur die Room-ID, keine Änderung an bestehender Room-/Guest-Logik nötig, sofern nicht anders entschieden.

---

## 5. Benötigte Tests

- **Unit-Tests (Service-Schicht)**, analog zu `tests/test_guest_service.py` / `tests/test_room_service.py`:
  - Nachricht erstellen (gültiger Raum, gültiger Sender/Text)
  - Nachricht erstellen mit ungültigem Raum → Fehlerfall
  - Alle Nachrichten auflisten
  - Nachrichten nach Raum filtern
  - Einzelne Nachricht per ID abrufen (inkl. Not-Found-Fall)
  - Statuswechsel `sent → delivered`, `delivered → read` (und ggf. Ablehnung ungültiger Übergänge, falls diese Regel eingeführt wird)
- **Integrationstests (API)**, analog zu `tests/test_api.py`:
  - `POST` neue Nachricht → 201 + korrekter Body
  - `GET` Liste aller Nachrichten
  - `GET` Liste gefiltert nach Raum
  - `GET` einzelne Nachricht → 200 / 404
  - Status-Update-Endpunkt → 200 + aktualisierter Status
  - Persistenz über Neustart (ggf. als Hinweis, dass SQLite-Datei genutzt wird — bestehendes Testmuster mit `conftest.py` prüfen, ob In-Memory-DB verwendet wird)
- Prüfen, ob `tests/conftest.py` bereits eine Test-DB-Fixture bereitstellt, die für Message-Tests wiederverwendet werden kann.

---

## 6. Benötigte Dokumentationsupdates

- **`docs/architecture.md`** — existiert nicht, muss gemäß `docs/documentation_structure.md` neu angelegt werden (Architekturüberblick, Komponentenstruktur, Schichtenverantwortung, Datenmodellüberblick, externe Abhängigkeiten, architektonische Einschränkungen) und dabei die neue Message-Komponente einschließen.
- **`docs/api.md`** — existiert ebenfalls nicht, muss neu angelegt werden (Endpunkte, Request-/Response-Strukturen, Statuscodes, Beispiel-Payloads) für alle bestehenden Endpunkte (rooms, guests, checkinout) **plus** die neuen Message-Endpunkte.
- **`docs/decisions.md`** — neuer Eintrag für: Datenbankdesign der Message-Tabelle, Zustellmechanismus (synchron, Option A gemäß `specs/architecture_options.md`), Read-Status-Handling, Lösung für den fehlenden Auth-Kontext bei der Gastsicht.
- **`docs/changelog.md`** — neuer Abschnitt „Added" nach Abschluss der Implementierung.
- **`docs/overview.md`** — „Scope Boundaries" nennt aktuell „Messaging / Notifications" als nicht im Scope; muss nach Einführung des Features aktualisiert werden (Formulierung anpassen bzw. Messaging als neue Major Capability ergänzen).

---

## 7. Offene Entscheidungen

Die Spezifikation benennt diese Punkte selbst als bewusst offen; sie müssen vor oder während der Implementierung entschieden werden:

1. **Guest-Zugriff ohne Authentifizierung** — Die Spec fordert, dass Gäste "ihre" raumbezogenen Nachrichten sehen können, schließt Authentifizierung aber explizit aus (sowohl in `chat_feature_spec.md` als auch grundsätzlich in `basis_spec.md`). Wie identifiziert das System, welcher Gast/welches Zimmer eine Sitzung anfragt? Optionen: Raum-ID als URL-Parameter (z. B. `/api/messages?room_id=12`, keine echte Zugriffskontrolle), ein einfacher Zimmer-Code, oder die Guest-Ansicht bleibt bewusst ungeschützt/rein clientseitig gefiltert. Muss vor UI-Implementierung geklärt werden.
2. **Datenbankdesign** — Eigene Tabelle `messages` mit `room_id` als Fremdschlüssel (analog `guests.room_id`) erscheint naheliegend und konsistent mit bestehendem Schema; zu bestätigen.
3. **API-Design** — Endpunkt-Struktur, z. B. `POST /api/messages`, `GET /api/messages?room_id=`, `GET /api/messages/{id}`, `PATCH /api/messages/{id}/status`. Zu entscheiden: eigener Status-Endpunkt vs. generisches Update.
4. **Sender-Feld** — Spec verlangt "Sender" als Metadatum, aber ohne Authentifizierung gibt es keinen Benutzerkontext. Klärungsbedarf: freies Textfeld (z. B. "Reception"), festes Enum (`reception` / `guest`), oder Name des Mitarbeiters als Freitext.
5. **Read-Status-Handling** — Wer setzt den Status auf `delivered`/`read` und wann? Automatisch bei Abruf durch die Guest-Ansicht, oder ein expliziter Nutzeraktion? Spec lässt dies offen.
6. **Zustellmechanismus** — `specs/architecture_options.md` empfiehlt Option A (direkte Persistenz, synchrone REST-API, kein Broker) für dieses Trainingsprojekt; sollte als Entscheidung in `decisions.md` festgehalten werden, sofern das Team dem folgt.
7. **Frontend-Design** — Eine gemeinsame Seite mit Rollenumschaltung (Reception/Guest) vs. zwei getrennte Seiten. Gegebenenfalls auch, ob die Guest-Sicht überhaupt Teil dieser ersten Iteration ist oder auf eine Folgeiteration verschoben wird.
8. **`docs/architecture.md` und `docs/api.md` fehlen komplett** — das ist kein Punkt aus der Spec, aber eine Voraussetzung, um die von der Spec geforderten Updates überhaupt vornehmen zu können (siehe Risiken).

---

## 8. Risiken

- **Fehlende Basisdokumentation:** `docs/architecture.md` und `docs/api.md` sind laut `docs/documentation_structure.md` Pflichtdateien, existieren im Repository aber nicht. Die Spec verlangt, beide zu aktualisieren — das ist ohne vorherige Neuanlage nicht möglich. Empfehlung: beide Dateien zunächst mit dem Ist-Zustand (Rooms/Guests/Checkinout) befüllen, dann um die Chat-Funktion erweitern, damit Dokumentation und Code nicht auseinanderlaufen (Documentation-First-Prinzip aus `CLAUDE.md`).
- **Ungeklärter Guest-Zugriff ohne Auth:** Ohne Authentifizierung besteht das Risiko, dass jede Person mit Kenntnis einer Raum-ID/URL fremde Nachrichten einsehen kann. Für dieses Trainingsprojekt laut Spec akzeptabel, sollte aber explizit als bekannte Einschränkung dokumentiert werden (analog zu bestehenden "Known Limitations" in `basis_spec.md`), damit es nicht als Sicherheitslücke missverstanden wird.
- **Statusmodell-Mehrdeutigkeit:** Ohne klare Regeln, wer den Status wann setzt, könnten Reception und Guest-Ansicht inkonsistente Annahmen treiben (z. B. Status "read", obwohl niemand ihn tatsächlich gelesen hat). Sollte früh im Service-Layer festgelegt werden (siehe Offene Entscheidung 5).
- **Bestehendes `_drop_non_ascii`-Muster in `guest_service.py`:** Falls dasselbe Muster für Message-Text übernommen wird, sollte geprüft werden, ob das für Chat-Inhalte (evtl. Umlaute, Sonderzeichen) gewünscht ist — sonst Inkonsistenz mit der übrigen Codebasis vermeiden oder bewusst dokumentieren.
- **Rückwärtskompatibilität:** Spec fordert Abwärtskompatibilität; da Message eine komplett neue, unabhängige Entity ist (kein Eingriff in `Room`/`Guest`-Schema notwendig), ist das Risiko gering — sollte aber während der Implementierung nicht durch nachträgliche Änderungen an `Room`/`Guest` verletzt werden.
- **Kein festgelegter Startpunkt für offene Fragen:** Da mehrere Kernentscheidungen (Abschnitt 7) noch offen sind, besteht das Risiko, ohne vorherige Abstimmung mit stillschweigenden Annahmen zu implementieren, die später revidiert werden müssen — insbesondere bei Guest-Zugriff und Statuslogik.

---

## Empfehlung für nächsten Schritt

Kein Code wurde geändert. Vor Beginn der Implementierung sollten insbesondere die Punkte in Abschnitt 7 (v. a. Guest-Zugriff und Statuslogik) sowie das Vorgehen bei den fehlenden Dokumenten `architecture.md`/`api.md` (Abschnitt 8) mit dem Team abgestimmt werden, bevor ein Implementierungsplan gemäß Workflow-Schritt 3 erstellt wird.
