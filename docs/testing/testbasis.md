# Testbasis: Hotel-Management-Anwendung mit Messaging

**Erstellungsdatum:** 2026-07-30  
**Projektstand:** Version 1.4.0  
**Basis-Analyse:** `docs/testing/analyse_20260730.md`

---

## 1. Ziel der Testaktivitäten

Die Testaktivitäten sollen die Funktionsfähigkeit, Datenintegrität und Benutzerfreundlichkeit der Hotel-Management-Anwendung verifizieren. Der Fokus liegt auf:

- **Raum- und Gästemanagement:** Korrekte Verwaltung von Räumen und Gästen gemäß definierter Geschäftsregeln
- **Check-in/Check-out-Prozesse:** Validierung der Statusübergänge und Zimmerzuweisungen
- **Messaging-Funktion:** Nachrichtenaustausch zwischen Rezeption und Gästen, inklusive Status-Tracking
- **API-Verhalten:** Übereinstimmung zwischen API-Dokumentation und Implementierung
- **Datenintegrität:** Korrektheit von Daten unter normalen und Grenzfall-Bedingungen

Explizit **nicht** im Fokus: Authentifizierung, Autorisierung, Push-Benachrichtigungen, Echtzeit-Kommunikation (gemäß Scope Boundaries).

---

## 2. Testgegenstand

**Anwendung:** Hotel-Management-System  
**Architektur:** FastAPI-Backend (Python, SQLite), HTML/JS-Frontend  
**Version:** 1.4.0  
**Deployment:** Docker Compose

**Komponenten:**
- REST API (`/api/rooms`, `/api/guests`, `/api/messages`, `/api/guests/{id}/checkin`, `/api/guests/{id}/checkout`)
- Web-Frontend (Rezeption: `rooms.html`, `guests.html`, `checkin.html`, `messages.html`)
- Web-Frontend (Gast: `guest_messages.html`)
- Datenbank (SQLite: `data/hotel.db`)

**Quelle:** `docs/architecture.md` (Zeilen 1-23), `docs/overview.md` (Zeilen 1-18), `app/main.py`

---

## 3. Betrachtete fachliche und technische Quellen

### 3.1 Spezifikationen

- **`specs/basis_spec.md`** — Grundanforderungen für Raum-Management, Gäste-Management, Check-in/Check-out; definiert Scope-Grenzen (keine Authentifizierung)
- **`specs/chat_feature_spec.md`** — Anforderungen an Messaging-Feature (Senden, Empfangen, Status-Tracking); Out-of-Scope: Push-Notifications, Echtzeit-Kommunikation, Message-Attachments, Message-Deletion (Zeilen 170-181)
- **`specs/architecture_options.md`** — Architektur-Entscheidungen für Messaging (Option A: Direct Persistence gewählt)

**Quelle:** Analyse Abschnitt 3.1

### 3.2 Projektdokumentation

- **`docs/overview.md`** — Systemübersicht, Business-Kontext, Hauptfunktionen, Workflows, Scope Boundaries (Zeilen 32-38)
- **`docs/architecture.md`** — Architekturübersicht, Schichtenmodell (API / Services / Repositories), Datenmodell (Zeilen 1-119)
- **`docs/api.md`** — Vollständige API-Referenz mit Request/Response-Beispielen, Status-Codes (Zeilen 1-210)
- **`docs/decisions.md`** — Technische Entscheidungen (Decision 001-009), u.a. Decision 006 (Messaging), Decision 007 (UTF-8), Decision 008 (Gastsicht), Decision 009 (Checkout → cleaning)
- **`docs/changelog.md`** — Versionshistorie (1.0.0 bis Unreleased)
- **`CLAUDE.md`** — Entwicklungs-Workflow, Qualitätsstandards

**Quelle:** Analyse Abschnitt 3.2

### 3.3 Implementierung

**Backend:**
- `app/models.py` — Datenmodelle (Room, Guest, Message; Status-Enums: RoomStatus, MessageStatus)
- `app/services/*.py` — Business-Logik mit Geschäftsregeln
- `app/repositories/*.py` — Datenzugriff (SQLAlchemy)
- `app/api/*.py` — FastAPI-Router

**Frontend:**
- `static/*.html` — UI-Seiten
- `static/js/*.js` — Client-seitige Logik
- `static/css/style.css` — Stylesheet

**Datenbank:**
- SQLite unter `data/hotel.db`

**Tests (aktuell):**
- `tests/test_checkout_service.py` — Ein Unit-Test für Check-out-Service

**Quelle:** Analyse Abschnitt 3.3, 3.4

---

## 4. Funktionen innerhalb des Testumfangs

### 4.1 Raum-Management

**Quelle:** `docs/overview.md` (Zeilen 13-16), `docs/api.md` (Zeilen 9-47), `app/models.py` (Zeilen 14-23)

**Funktionen:**
- Liste aller Räume abrufen (`GET /api/rooms`)
- Einzelnen Raum abrufen (`GET /api/rooms/{id}`)
- Raumstatus ändern (`PATCH /api/rooms/{id}/status`)

**Raumstatus:**
- `available` — Raum verfügbar für Check-in
- `occupied` — Raum belegt
- `cleaning` — Raum wird gereinigt

**Geschäftsregel Statuswechsel:**  
**Quelle:** `docs/decisions.md` (Decision 009), `app/services/room_service.py` (Zeilen 18-25)
- Ein Raum im Status `occupied` kann nur zu `cleaning` gewechselt werden
- Direkter Wechsel `occupied → available` ist blockiert (HTTP 409 Conflict)

### 4.2 Gäste-Management

**Quelle:** `docs/overview.md` (Zeilen 13-16), `docs/api.md` (Zeilen 50-108), `app/models.py` (Zeilen 25-36)

**Funktionen:**
- Gast anlegen (`POST /api/guests`) — Vorname, Nachname
- Liste aller Gäste abrufen (`GET /api/guests`)
- Einzelnen Gast abrufen (`GET /api/guests/{id}`)
- Gast bearbeiten (`PUT /api/guests/{id}`) — Vorname, Nachname
- Gast löschen (`DELETE /api/guests/{id}`)

**Geschäftsregel Löschen:**  
**Quelle:** `app/services/guest_service.py` (Zeilen 26-33), `docs/api.md` (Zeilen 106-108)
- Ein Gast mit aktiver Zimmerzuweisung (`room_id != null`) kann nicht gelöscht werden (HTTP 409 Conflict)

**Zeichensatz-Behandlung:**  
**Quelle:** `docs/decisions.md` (Decision 007), `docs/changelog.md` (Version 1.3.1, Zeilen 35-38)
- Seit Version 1.3.1: UTF-8-Zeichen (ä, ö, ü, ß) werden korrekt gespeichert
- Vor Version 1.3.1: ASCII-Sanitierung entfernte Umlaute
- Keine Datenmigration für Altdaten

### 4.3 Check-in / Check-out

**Quelle:** `docs/overview.md` (Zeilen 20-30), `docs/api.md` (Zeilen 111-137), `app/services/checkinout_service.py`

**Check-in (`POST /api/guests/{id}/checkin`):**
- Weist einem Gast einen verfügbaren Raum zu
- Setzt Raum-Status auf `occupied`
- Speichert Check-in-Datum

**Geschäftsregeln Check-in:**  
**Quelle:** `app/services/checkinout_service.py` (Zeilen 8-22), `docs/api.md` (Zeilen 124-127)
- Gast darf noch keinen Raum haben (`room_id == null`)
- Raum muss Status `available` haben
- Bei Verletzung: HTTP 409 Conflict

**Check-out (`POST /api/guests/{id}/checkout`):**
- Entfernt Zimmerzuweisung vom Gast
- Setzt Raum-Status auf `cleaning`
- Speichert Check-out-Datum

**Geschäftsregeln Check-out:**  
**Quelle:** `app/services/checkinout_service.py` (Zeilen 25-34), `docs/api.md` (Zeilen 132-137), `docs/decisions.md` (Decision 009), `tests/test_checkout_service.py` (Zeilen 40-45)
- Gast muss einen Raum haben (`room_id != null`)
- Raum wird auf `cleaning` gesetzt (nicht direkt `available`)
- Bei Verletzung: HTTP 409 Conflict
- Ein vorhandener Unit-Test bestätigt `cleaning`-Status nach Check-out

### 4.4 Messaging — Rezeption

**Quelle:** `docs/decisions.md` (Decision 006), `docs/changelog.md` (Version 1.3.0), `app/models.py` (Zeilen 44-54), `docs/api.md` (Zeilen 140-210)

**Funktionen:**
- Nachricht an einen Raum senden (`POST /api/messages`)
- Alle Nachrichten auflisten (`GET /api/messages`)
- Nachrichten nach Raum filtern (`GET /api/messages?room_id={id}`)
- Einzelne Nachricht abrufen (`GET /api/messages/{id}`)
- Nachrichtenstatus ändern (`PATCH /api/messages/{id}/status`)

**Nachrichtenmodell:**  
**Quelle:** `app/models.py` (Zeilen 44-54), `docs/architecture.md` (Zeilen 78-82)
- `id` — Primärschlüssel
- `sender` — Freitext-String (kein Enum)
- `room_id` — Fremdschlüssel zu `rooms.id` (required)
- `content` — Nachrichtentext
- `created_at` — UTC-Zeitstempel (serverseitig gesetzt)
- `status` — Enum: `sent` / `delivered` / `read` (Default: `sent`)

**Status-Übergänge:**  
**Quelle:** `app/services/message_service.py` (Zeilen 7-11, 32-39), `docs/api.md` (Zeilen 202-205)
- Erlaubte Übergänge: `sent → delivered → read`
- Nicht erlaubt: Rückwärts-Wechsel, Überspringen von Zuständen
- Bei Verletzung: HTTP 409 Conflict
- Explizite Zustandsübergangstabelle in `message_service.py`

### 4.5 Messaging — Gast

**Quelle:** `docs/decisions.md` (Decision 008), `docs/changelog.md` (Version 1.4.0), `static/guest_messages.html`, `static/js/guest_messages.js`

**Funktionen:**
- Gastsicht über `/guest_messages.html?room_id={id}`
- Gast kann Nachrichten des Raums lesen
- Gast kann Nachrichten senden
- Automatische Status-Transition `sent → delivered` beim Laden von Rezeptionsnachrichten
- Manuelles Setzen von `read` über Button

**Gast-Identifizierung:**  
**Quelle:** `docs/decisions.md` (Decision 008)
- Keine Authentifizierung
- Raum-ID als URL-Parameter (`?room_id=`)
- Jeder mit URL kann Nachrichten dieses Raums einsehen und senden

**Sender-Kennzeichnung:**  
**Quelle:** `static/js/guest_messages.js` (Zeilen 1, 8-9, 104), `docs/decisions.md` (Decision 008)
- Gast-Nachrichten: fester Sender-String `"Guest (Room {number})"`
- Identifikation: String-Präfix-Check `sender.startsWith("Guest (")`

**Auto-Delivery-Mechanismus:**  
**Quelle:** `static/js/guest_messages.js` (Zeilen 43-53, 64-71)
- Beim Laden der Gastsicht: Nachrichten mit Status `sent`, die NICHT vom Gast stammen, werden automatisch auf `delivered` gesetzt
- `read` bleibt explizite Aktion

---

## 5. Funktionen außerhalb des Testumfangs

**Quelle:** `specs/basis_spec.md` (Zeile 33), `specs/chat_feature_spec.md` (Zeilen 170-181), `docs/overview.md` (Zeilen 32-38)

**Explizit nicht im Scope (gemäß Spezifikation):**
- Authentifizierung
- Autorisierung
- Push-Benachrichtigungen
- Echtzeit-Kommunikation (Websockets)
- Mobile Anwendungen
- Message-Attachments
- Message-Deletion

**Dokumentation:**
- Die Spezifikationen schließen diese Features explizit aus
- `docs/overview.md` (Scope Boundaries) nennt „Push notifications" und „Real-time communication" als „Not in scope for the initial version"

---

## 6. Bekannte Rahmenbedingungen und Einschränkungen

### 6.1 Architektonische Einschränkungen

**Quelle:** `docs/architecture.md` (Zeilen 106-119), `docs/decisions.md` (Decision 001, Decision 002, Decision 006)

- **Keine Authentifizierung:** Alle API-Endpunkte sind ohne Credentials erreichbar (Design-Entscheidung für Trainingsprojekt)
- **Synchrone Kommunikation:** Request/Response-Modell, kein Realtime-Push (Polling ist einzige Aktualisierungsmethode)
- **Einzelne SQLite-Datenbank:** Shared zwischen allen Entitäten, keine Mandantentrennung
- **Frontend ohne Build-Step:** Plain HTML/JS, keine Frameworks (Decision 001)
- **Geschäftsregeln in Service-Schicht:** Enforcement nicht auf DB-Schema-Ebene

### 6.2 Bekannte Limitationen

**Sender-Impersonation:**  
**Quelle:** `docs/decisions.md` (Decision 006, Absatz „Consequences")
- `sender` ist Freitext ohne Authentifizierung
- Keine Verhinderung von Impersonation
- Als bekannte Limitation akzeptiert

**Gast-Zugriff ohne Authentifizierung:**  
**Quelle:** `docs/decisions.md` (Decision 008)
- Jeder mit Kenntnis einer Raum-ID kann Nachrichten dieses Raums lesen/senden
- Als bewusste Design-Entscheidung dokumentiert (konsistent mit No-Auth-Scope)

**Historische Datenqualität:**  
**Quelle:** `docs/changelog.md` (Version 1.3.1, Zeile 38)
- Vor Version 1.3.1 erstellte Gäste können verstümmelte Namen haben (z. B. „Jrg" statt „Jörg")
- Keine Datenmigration erfolgt

**Test-Coverage:**  
**Quelle:** `docs/changelog.md` (Version 1.0.0, Zeile 95; Unreleased, Zeile 18), `tests/`-Verzeichnis
- Nur ein Unit-Test vorhanden (`tests/test_checkout_service.py`)
- Keine API-Integrationstests vorhanden
- Laut Changelog (Version 1.3.0) sollten Message-Tests existieren, aber im Repository nicht gefunden

### 6.3 Technologie-Stack

**Quelle:** `docs/architecture.md` (Zeilen 96-102), `specs/basis_spec.md` (Zeilen 105-112)

- **Backend:** Python, FastAPI, SQLAlchemy, SQLite
- **Frontend:** HTML5, Vanilla JavaScript (ES6+), CSS
- **Deployment:** Docker, Docker Compose
- **Datenbank:** SQLite (Pfad über `DATABASE_URL` Environment-Variable konfigurierbar)

---

## 7. Belegte fachliche Anforderungen

### 7.1 Raum-Status-Lifecycle

**Anforderung:** Ein ausgecheckter Raum muss gereinigt werden, bevor er wieder eingecheckt werden kann.

**Quelle:** `docs/overview.md` (Zeilen 28-30), `docs/decisions.md` (Decision 009), `specs/basis_spec.md` (Zeilen 96-98)

**Implementierung:** 
- Check-out setzt Raum auf `cleaning` (nicht `available`)
- Nur Räume mit Status `available` können eingecheckt werden
- Manueller Statuswechsel `cleaning → available` erforderlich

**Verifikation:** `tests/test_checkout_service.py` (Zeilen 40-45)

### 7.2 Gast-Zimmerzuweisung

**Anforderung:** Ein Gast kann zu einem Zeitpunkt höchstens einem Raum zugewiesen sein.

**Quelle:** `app/services/checkinout_service.py` (Zeilen 12-13), `docs/api.md` (Zeilen 126-127)

**Implementierung:**
- Check-in prüft, ob Gast bereits `room_id` hat
- Bei bestehender Zuweisung: HTTP 409 Conflict

**Anmerkung:** Datenbankschema erlaubt theoretisch mehrere Gäste pro Raum (`Guest.room_id` FK ohne UNIQUE-Constraint), aber Service-Schicht prüft dies nicht aktiv beim Check-in. Siehe Abschnitt 9 (Offene Fragen).

### 7.3 Nachrichtenstatus-Progression

**Anforderung:** Der Status einer Nachricht kann nur vorwärts schreiten: `sent → delivered → read`.

**Quelle:** `specs/chat_feature_spec.md` (Zeilen 57-67), `app/services/message_service.py` (Zeilen 7-11)

**Implementierung:**
- Explizite Zustandsübergangstabelle (`ALLOWED_TRANSITIONS`)
- Rückwärts-Wechsel oder Überspringen führt zu HTTP 409 Conflict

### 7.4 Nachrichtenpersistenz

**Anforderung:** Nachrichten müssen dauerhaft gespeichert werden und Anwendungsneustart überstehen.

**Quelle:** `specs/chat_feature_spec.md` (Zeilen 49-53)

**Implementierung:**
- Nachrichten in SQLite-Datenbank (`messages`-Tabelle)
- Persistenz über `data/hotel.db`

### 7.5 Gast-Nachrichtenansicht

**Anforderung:** Gäste sollen Nachrichten ihres Raums sehen können.

**Quelle:** `specs/chat_feature_spec.md` (Zeilen 43-45, User Story 2)

**Implementierung:**
- Gastsicht über `/guest_messages.html?room_id={id}`
- Filterung über `GET /api/messages?room_id={id}`

**Scope-Erweiterung:** Laut `docs/decisions.md` (Decision 008) wurde Scope bewusst erweitert, um auch Senden von Gast-Nachrichten zu ermöglichen (nicht nur Empfangen).

---

## 8. Dokumentierte Annahmen

Die folgenden Punkte sind in der Implementierung vorhanden, aber nicht explizit als fachliche Anforderungen in den Spezifikationen dokumentiert. Sie stellen Implementierungsverhalten dar.

### 8.1 Zeitstempel

**Annahme:** Nachrichten-Zeitstempel werden in UTC gespeichert, Frontend zeigt sie in Browser-Lokalzeit an.

**Implementierung:**  
- `app/models.py` (Zeile 51): `created_at = Column(DateTime, default=datetime.utcnow)`
- `static/js/guest_messages.js` (Zeile 81): `new Date(m.created_at).toLocaleString()`

**Quelle-Analyse:** Analyse Abschnitt 4.4

**Status:** Keine explizite Anforderung in Spezifikationen, aber konsistentes Verhalten.

### 8.2 Auto-Delivery-Definition

**Annahme:** Der Status `delivered` bedeutet „Gastsicht hat die Nachricht via API abgerufen" (nicht „Gast hat Nachricht gesehen").

**Implementierung:**  
- `static/js/guest_messages.js` (Zeilen 43-53): Automatische Transition `sent → delivered` beim API-Aufruf
- Keine Prüfung, ob Nachricht im Viewport sichtbar war

**Quelle-Analyse:** Analyse Abschnitt 4.4

**Status:** Implementierung vorhanden, aber fachliche Definition von „delivered" nicht in Spezifikation dokumentiert. Siehe Abschnitt 9 (Offene Fragen).

### 8.3 Sender-Feld Freitext

**Annahme:** Das Sender-Feld ist Freitext ohne Validierung.

**Implementierung:**  
- `app/models.py` (Zeile 48): `sender = Column(String, nullable=False)`
- Keine Enum-Validierung, keine Längen-Beschränkung

**Quelle-Analyse:** `docs/decisions.md` (Decision 006)

**Status:** Bewusste Design-Entscheidung (Decision 006), keine Authentifizierung vorhanden. Ermöglicht Impersonation (siehe Abschnitt 6.2).

### 8.4 Raum-Kategorien

**Annahme:** Raum-Kategorien (Single, Double, Suite) sind informativ, aber nicht validiert.

**Implementierung:**  
- `app/models.py` (Zeile 19): `category = Column(String, nullable=False)`
- Keine Enum-Validierung

**Quelle-Analyse:** Analyse Abschnitt 4.1

**Status:** Kategorien in Seed-Daten (`app/seed.py`) vorhanden, aber kein Constraint. Siehe Abschnitt 9 (Offene Fragen).

### 8.5 Check-in-Datum als `date.today()`

**Annahme:** Check-in-Datum ist das Python-serverseitige Datum (ohne Zeitzone).

**Implementierung:**  
- `app/services/checkinout_service.py` (Zeile 22): `date.today()`
- Kein Timezone-Handling dokumentiert

**Quelle-Analyse:** Analyse Abschnitt 4.3

**Status:** Keine Anforderung zur Zeitzone in Spezifikation. Siehe Abschnitt 9 (Offene Fragen).

---

## 9. Offene fachliche Fragen

Die folgenden Fragen konnten anhand der verfügbaren Quellen nicht abschließend beantwortet werden und erfordern Klärung mit dem Fachbereich.

### 9.1 Raum-Verwaltung

**Frage 1: Mehrfach-Belegung**  
Kann ein Raum gleichzeitig mehreren Gästen zugewiesen sein?

**Hintergrund:**  
- Datenbankschema erlaubt mehrere Gäste pro Raum (`Guest.room_id` FK ohne UNIQUE-Constraint)
- `docs/architecture.md` (Zeile 87) erwähnt „at most one currently-checked-in guest is enforced at the service layer, not the schema"
- Check-in-Service prüft nur, ob Raum `available` ist, nicht, ob bereits ein anderer Gast eingecheckt ist

**Implikation:** Ohne Klärung unklar, ob Test-Fälle für Mehrfach-Belegung erforderlich sind.

**Frage 2: Raum-Kategorien**  
Sind Raum-Kategorien (Single, Double, Suite) feste Werte oder beliebige Strings?

**Hintergrund:**  
- Seed-Daten enthalten „Single", „Double", „Suite"
- Kein Enum oder Constraint im Modell (`app/models.py`, Zeile 19)

**Implikation:** Unklar, ob Validierungstests für ungültige Kategorien erforderlich sind.

**Frage 3: Cleaning-Workflow**  
Wer darf einen Raum von `cleaning` auf `available` setzen?

**Hintergrund:**  
- Statuswechsel ist über API möglich (`PATCH /api/rooms/{id}/status`)
- Keine Rollendifferenzierung (keine Authentifizierung)

**Implikation:** Unklar, ob Geschäftsregel für Freigabe existiert.

### 9.2 Gäste-Verwaltung

**Frage 4: Namensvalidierung**  
Welche Zeichen sind in Gast-Namen erlaubt? Gibt es Längenbeschränkungen?

**Hintergrund:**  
- Seit Version 1.3.1 werden UTF-8-Zeichen akzeptiert (Decision 007)
- Keine dokumentierte Validierung außer `nullable=False`

**Implikation:** Testfälle für Sonderzeichen, Zahlen, Emojis, Längen unklar.

**Frage 5: Gast-Löschung**  
Ist das Löschen von Gästen ohne Raumzuweisung fachlich korrekt?

**Hintergrund:**  
- API erlaubt Löschen von Gästen mit `room_id == null`
- Check-in/out-Daten werden mit Gast gelöscht (keine Audit-Tabelle)

**Implikation:** Unklar, ob historische Daten erhalten bleiben sollen.

### 9.3 Check-in / Check-out

**Frage 6: Zeitzone für Check-in/out-Datum**  
In welcher Zeitzone werden Check-in- und Check-out-Daten gespeichert und angezeigt?

**Hintergrund:**  
- `date.today()` nutzt Server-Zeitzone
- Keine Zeitzone-Konvertierung dokumentiert

**Implikation:** Tests für Zeitzonen-Grenzfälle unklar.

**Frage 7: Zimmerwechsel**  
Ist ein direkter Check-in in einen anderen Raum ohne vorherigen Check-out erlaubt?

**Hintergrund:**  
- Check-in-Service verweigert Check-in, wenn Gast bereits `room_id` hat (HTTP 409)
- Kein „Transfer"-Endpoint dokumentiert

**Implikation:** Unklar, ob Zimmerwechsel-Workflow erforderlich ist.

**Frage 8: Check-out ohne Check-in**  
Was passiert, wenn ein Gast manuell `room_id = null` gesetzt bekommt?

**Hintergrund:**  
- Check-out-Service verweigert Check-out bei `room_id == null` (HTTP 409)
- Unklar, ob `check_in_date` bei direkter DB-Manipulation erhalten bleibt

**Implikation:** Datenintegrität bei manuellen DB-Änderungen unklar.

### 9.4 Messaging

**Frage 9: Nachricht an leeren Raum**  
Darf eine Nachricht an einen Raum ohne aktiven Gast gesendet werden?

**Hintergrund:**  
- Service prüft nur Raum-Existenz, nicht Gast-Zuweisung
- Aktuell erlaubt

**Implikation:** Unklar, ob das fachlich korrekt ist.

**Frage 10: Nachrichtenlöschung**  
Wie werden Nachrichten archiviert oder gelöscht?

**Quelle:** `specs/chat_feature_spec.md` (Zeile 180) schließt Message-Deletion explizit aus

**Hintergrund:**  
- Keine API-Endpunkte für Löschung
- Keine Dokumentation zu GDPR oder Datenbereinigung

**Implikation:** Unklar, ob Testfälle für Datenarchivierung erforderlich sind.

**Frage 11: Zeitstempel-Anzeige**  
Soll Frontend Nachrichtenzeitstempel in Lokalzeit oder UTC anzeigen?

**Hintergrund:**  
- Backend speichert UTC (`datetime.utcnow()`)
- Frontend nutzt `toLocaleString()` (browserbasiert)

**Implikation:** Keine explizite Anforderung zur Darstellung.

**Frage 12: Sender-Feld Rezeption**  
Ist „Reception" ein vorgegebener Wert oder darf der Mitarbeiter seinen Namen eingeben?

**Hintergrund:**  
- `static/messages.html` (Zeile 31) zeigt Defaultwert „Reception"
- Freitext-Eingabe erlaubt

**Implikation:** Unklar, ob Validierung erforderlich ist.

**Frage 13: Status-Korrektur**  
Gibt es einen Prozess, um versehentlich gesetzte Status zu korrigieren?

**Hintergrund:**  
- Status-Übergänge nur vorwärts erlaubt
- Keine „Reset"-Funktion dokumentiert

**Implikation:** Unklar, ob Fehlerkorrektur-Workflow existiert.

**Frage 14: Gastsicht-Raumauswahl**  
Ist es fachlich korrekt, dass ein Gast alle Räume sehen kann?

**Hintergrund:**  
- `/guest_messages.html` ohne `room_id` zeigt Liste aller Räume
- Keine Einschränkung implementiert

**Implikation:** Unklar, ob das der fachlichen Anforderung entspricht.

**Frage 15: Definition „delivered"**  
Bedeutet „delivered", dass die Nachricht API-seitig abgerufen wurde, oder dass sie im Browser angezeigt wurde?

**Hintergrund:**  
- Auto-Delivery setzt Status beim API-Aufruf, nicht bei Viewport-Sichtbarkeit
- Keine Definition in Spezifikation

**Implikation:** Unklar, ob Implementierung fachlich korrekt ist.

---

## 10. Gefundene Widersprüche

### 10.1 WIDERSPRUCH: Checkout-Status in Decision 003 vs. Decision 009

**Quelle:** `docs/decisions.md`

**Decision 003 (Zeilen 33-48):**  
„The checkout process sets the room to `available` automatically"

**Decision 009 (Zeilen 142-151):**  
„Checkout moves the assigned room from `occupied` to `cleaning`"

**Status-Notiz:** Decision 003 enthält Vermerk „Superseded by [Decision 009]"

**Aktueller Stand:**
- Implementierung folgt Decision 009 (`app/services/checkinout_service.py`, Zeile 33)
- Test bestätigt `cleaning`-Status (`tests/test_checkout_service.py`, Zeile 45)

**Auflösung:** Decision 009 ist gültig. Decision 003 ist historisch und kann ignoriert werden.

### 10.2 WIDERSPRUCH: Test-Suite-Status

**Quelle:** `docs/changelog.md`

**Version 1.0.0 (Zeile 95-96):**  
„Unit tests for service layer (22 tests), Integration tests for all API endpoints (happy paths)"

**Version 1.3.0 (Zeile 48):**  
„Unit tests for the message service layer, integration tests for the messages API"

**Unreleased (Zeile 18):**  
„Removed: Pytest suite and test-only dependencies"

**Aktueller Stand:**
- Nur 1 Test vorhanden (`tests/test_checkout_service.py`)
- Keine API-Integrationstests gefunden
- Keine Message-Tests gefunden

**Widerspruch:**
- Changelog behauptet, dass Message-Tests existieren (Version 1.3.0)
- Repository enthält sie nicht

**Implikation:** Changelog möglicherweise veraltet. Test-Coverage muss vollständig neu erstellt werden.

### 10.3 INKONSISTENZ: Scope Boundaries in overview.md

**Quelle:** `docs/overview.md`

**Zeile 17 (Major Capabilities):**  
„**Messaging** — Reception can send a message to a room, [...] The separated **Guest Chat** entry [...] opens a room selector"

**Zeilen 34-38 (Scope Boundaries):**  
„Not in scope for the initial version: [...] Push notifications, Real-time communication"

**Inkonsistenz:**
- Messaging ist implementiert und wird unter „Major Capabilities" aufgeführt
- „Scope Boundaries" wurde nicht aktualisiert, um klarzustellen, dass Messaging (ohne Push/Realtime) nun „in scope" ist

**Klarstellung:**
- Messaging **ist** im Scope (seit Version 1.3.0 / 1.4.0)
- Push Notifications und Real-time Communication bleiben **out of scope**

---

## 11. Erste bekannte Produktrisiken

### 11.1 Sicherheit

**RISIKO: Keine Authentifizierung / Autorisierung**  
**Schweregrad:** HOCH  
**Status:** Bekannte Limitation (Design-Entscheidung)  
**Quelle:** `docs/overview.md` (Zeilen 34-38), `specs/basis_spec.md` (Zeile 33), `docs/decisions.md` (Decision 008)

**Beschreibung:**
- Alle API-Endpunkte sind ohne Credentials erreichbar
- Jeder mit Kenntnis einer Raum-ID kann Nachrichten lesen und senden
- Potenziell anfällig für XSS (kein HTML-Escaping dokumentiert) und Injection-Angriffe (SQLAlchemy-ORM sollte schützen, aber nicht getestet)

**Test-Implikation:**
- XSS- und SQL-Injection-Szenarien sollten geprüft werden
- Penetrationstests für Authentifizierung nicht sinnvoll (out of scope)

**RISIKO: Sender-Impersonation**  
**Schweregrad:** MITTEL  
**Status:** Bekannte Limitation  
**Quelle:** `docs/decisions.md` (Decision 006)

**Beschreibung:**
- `sender` ist Freitext
- Gast könnte sich als „Reception" ausgeben (Client-Beschränkung ist umgehbar)

**Test-Implikation:**
- Prüfen, ob API falschen Sender ablehnt (Erwartung: Nein)

### 11.2 Datenintegrität

**RISIKO: Mehrfach-Check-in bei Race Conditions**  
**Schweregrad:** MITTEL  
**Status:** Annahme (nicht getestet)  
**Quelle:** `app/services/checkinout_service.py` (Zeilen 8-22)

**Beschreibung:**
- Check-in prüft `room.status == available`
- Keine explizite Datenbank-Transaktion mit Lock dokumentiert
- Bei gleichzeitigen Check-ins könnte derselbe Raum zweimal vergeben werden

**Test-Implikation:**
- Concurrency-Tests erforderlich (parallele Check-ins auf selben Raum)

**RISIKO: Status-Inkonsistenz bei Check-out**  
**Schweregrad:** MITTEL  
**Status:** Teilweise durch Unit-Test abgedeckt  
**Quelle:** `tests/test_checkout_service.py`, `docs/decisions.md` (Decision 009)

**Beschreibung:**
- Check-out setzt Raum auf `cleaning`
- Nur Service-Layer-Test vorhanden, keine API-Integrationstests

**Test-Implikation:**
- End-to-End-Tests über API erforderlich

**RISIKO: Nachrichten-Status-Race bei Auto-Delivered**  
**Schweregrad:** NIEDRIG  
**Status:** Annahme  
**Quelle:** `static/js/guest_messages.js` (Zeilen 43-53)

**Beschreibung:**
- Gastsicht führt Auto-Delivered in Schleife aus (ein PATCH pro Nachricht)
- Bei parallelen Gastsicht-Aufrufen: möglicherweise doppelte PATCH-Aufrufe
- Status-Übergangs-Logik verhindert Fehler, aber Performance-Risiko bei vielen Nachrichten

**Test-Implikation:**
- Verhalten bei vielen Nachrichten prüfen (z. B. 100+)
- Parallele Gastsicht-Aufrufe testen

### 11.3 Usability

**RISIKO: Kein Feedback bei Netzwerk-Fehlern**  
**Schweregrad:** MITTEL  
**Status:** Annahme (Code-Review erforderlich)  
**Quelle:** Stichprobe `static/js/messages.js`, `static/js/guest_messages.js`

**Beschreibung:**
- JavaScript-Dateien nutzen `fetch()` ohne konsistente Error-Handling-Strategie
- Beispiel: `guest_messages.js` (Zeile 99-109): POST ohne `.catch()` oder `if (!res.ok)` Check

**Test-Implikation:**
- Verhalten bei Server-Fehler (500), Netzwerk-Timeout, ungültigen Payloads prüfen

**RISIKO: Auto-Delivered ohne Sichtbarkeits-Check**  
**Schweregrad:** NIEDRIG  
**Status:** Design-Entscheidung (fachliche Klärung erforderlich)  
**Quelle:** `static/js/guest_messages.js` (Zeilen 43-53)

**Beschreibung:**
- Status `delivered` wird gesetzt, sobald Gastsicht API aufruft
- Keine Prüfung, ob Nachricht im Viewport sichtbar war

**Test-Implikation:**
- Fachliche Definition „delivered" klären (siehe Abschnitt 9, Frage 15)

### 11.4 Performance

**RISIKO: Unbegrenzte Nachrichten-Historie**  
**Schweregrad:** MITTEL (langfristig)  
**Status:** Offen (keine Dokumentation zu Archivierung)  

**Beschreibung:**
- Keine Pagination oder Archivierung dokumentiert
- Frontend lädt alle Nachrichten eines Raums
- Bei jahrelanger Nutzung: potenziell tausende Nachrichten pro Raum

**Test-Implikation:**
- Lasttests mit großen Nachrichtenmengen (z. B. 1000+ Nachrichten)

**RISIKO: N+1-Problem bei Nachrichten-Liste**  
**Schweregrad:** NIEDRIG (bei kleiner Datenmenge)  
**Status:** Annahme (nicht verifiziert)

**Beschreibung:**
- Nachrichten-Liste könnte `room`-Objekte lazy-laden
- Bei vielen Nachrichten: viele DB-Queries

**Test-Implikation:**
- DB-Query-Count messen bei großen Nachrichtenmengen

### 11.5 Datenqualität

**RISIKO: Historische Gäste mit korrupten Umlauten**  
**Schweregrad:** NIEDRIG  
**Status:** Bekannt, keine Migration geplant  
**Quelle:** `docs/changelog.md` (Version 1.3.1, Zeile 38)

**Beschreibung:**
- Vor Version 1.3.1 erstellte Gäste haben möglicherweise verstümmelte Namen (z. B. „Jrg" statt „Jörg")
- Keine Datenmigration erfolgt

**Test-Implikation:**
- Verhalten bei Anzeige/Suche von Gästen mit verstümmelten Namen prüfen

---

## 12. Nächste Schritte

1. **Fachliche Klärung:** Offene Fragen (Abschnitt 9) mit Product Owner abstimmen
2. **Risikopriorisierung:** Produktrisiken (Abschnitt 11) nach Schweregrad und Eintrittswahrscheinlichkeit bewerten
3. **Akzeptanzkriterien:** Basierend auf geklärten Anforderungen detaillierte Akzeptanzkriterien formulieren
4. **Testfallspezifikation:** Testfälle für Funktionen innerhalb des Testumfangs erstellen
5. **Test-Infrastruktur:** Basis für Unit-, Integration- und End-to-End-Tests aufbauen

---

**Ende der Testbasis**
