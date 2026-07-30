# Testfälle: Hotel-Management-Anwendung mit Messaging

**Erstellungsdatum:** 2026-07-30  
**Projektstand:** Version 1.4.0  
**Basis:** `docs/testing/akzeptanzkriterien.md`, `docs/testing/risikoanalyse.md`

---

## 1. Übersicht

Dieses Dokument beschreibt konkrete Testfälle für die Hotel-Management-Anwendung. Die Testfälle sind nach Priorisierung aus der Risikoanalyse strukturiert.

**Testfall-IDs:**
- **TC-ROOM-NNN:** Raum-Management
- **TC-GUEST-NNN:** Gäste-Management
- **TC-CHECKIN-NNN:** Check-in / Check-out
- **TC-MSG-NNN:** Messaging
- **TC-SEC-NNN:** Sicherheit

**Testebenen:**
- **Unit:** Test auf Ebene einzelner Funktionen/Methoden (Service-Layer)
- **Integration:** Test auf API-Ebene (HTTP-Request/Response)
- **E2E:** End-to-End-Test über UI (Browser)

**Automatisierung:**
- 🤖 = Kandidat für Automatisierung mit Robot Framework
- 🧪 = Manueller Test empfohlen (Sicherheit, explorative Tests)

---

## 2. Phase 1 — Kritische Tests (Priorität: KRITISCH / HOCH)

### TC-SEC-001: XSS-Schutz — HTML-Tags werden escaped 🤖

**Priorität:** KRITISCH  
**Risiko:** R-SEC-001  
**Akzeptanzkriterium:** AC-MSG-001 (indirekt, Nachricht erstellen)  
**Testebene:** Integration (API) + E2E (UI)

**Ziel:**  
Sicherstellen, dass HTML-Tags in Nachrichteninhalten nicht als HTML gerendert, sondern als Text angezeigt werden.

**Voraussetzungen:**
- Anwendung läuft
- Mindestens ein Raum existiert (z. B. Raum 101)

**Testdaten:**
- Raum-ID: 1 (Raum 101)
- Sender: „Reception"
- Nachrichteninhalt: `<b>Wichtige</b> Nachricht`

**Testschritte:**

1. **API-Test:**
   - POST `/api/messages` mit Body:
     ```json
     {
       "room_id": 1,
       "sender": "Reception",
       "content": "<b>Wichtige</b> Nachricht"
     }
     ```
   - Erwartetes Ergebnis: Status 201, Nachricht wird gespeichert

2. **UI-Test (Rezeptionsansicht):**
   - Öffne `/messages.html`
   - Prüfe Anzeige der Nachricht in Tabelle

3. **UI-Test (Gastsicht):**
   - Öffne `/guest_messages.html?room_id=1`
   - Prüfe Anzeige der Nachricht in Tabelle

**Erwartetes Ergebnis:**
- Nachricht wird in UI als Text angezeigt: `<b>Wichtige</b> Nachricht`
- HTML-Tags werden NICHT gerendert (d. h. Text ist nicht fett)
- Browser-Inspektor zeigt escaped HTML (z. B. `&lt;b&gt;Wichtige&lt;/b&gt; Nachricht`)

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(wird beim Testdurchlauf ausgefüllt: Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-SEC-002: XSS-Schutz — Script-Tag wird nicht ausgeführt 🧪

**Priorität:** KRITISCH  
**Risiko:** R-SEC-001  
**Akzeptanzkriterium:** AC-MSG-001 (indirekt)  
**Testebene:** Integration (API) + E2E (UI)

**Ziel:**  
Sicherstellen, dass JavaScript-Code in Nachrichteninhalten nicht ausgeführt wird.

**Voraussetzungen:**
- Anwendung läuft
- Mindestens ein Raum existiert (z. B. Raum 101)

**Testdaten:**
- Raum-ID: 1
- Sender: „Reception"
- Nachrichteninhalt: `<script>alert('XSS')</script>`

**Testschritte:**

1. **API-Test:**
   - POST `/api/messages` mit obigen Testdaten
   - Erwartetes Ergebnis: Status 201

2. **UI-Test (Rezeptionsansicht):**
   - Öffne `/messages.html`
   - Beobachte, ob Alert-Dialog erscheint

3. **UI-Test (Gastsicht):**
   - Öffne `/guest_messages.html?room_id=1`
   - Beobachte, ob Alert-Dialog erscheint

**Erwartetes Ergebnis:**
- KEIN Alert-Dialog wird angezeigt
- Nachrichteninhalt wird als Text angezeigt: `<script>alert('XSS')</script>`
- Browser-Console zeigt keine JavaScript-Fehler
- Script-Tag wird nicht ausgeführt

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

**Hinweis:** Manueller Test empfohlen (🧪), da Sicherheitsprüfung durch menschliche Beobachtung bestätigt werden sollte.

---

### TC-SEC-003: XSS-Schutz — Event-Handler wird nicht ausgeführt 🧪

**Priorität:** KRITISCH  
**Risiko:** R-SEC-001  
**Akzeptanzkriterium:** AC-MSG-001 (indirekt)  
**Testebene:** Integration (API) + E2E (UI)

**Ziel:**  
Sicherstellen, dass HTML-Event-Handler in Nachrichteninhalten nicht ausgeführt werden.

**Voraussetzungen:**
- Anwendung läuft
- Mindestens ein Raum existiert

**Testdaten:**
- Raum-ID: 1
- Sender: „Reception"
- Nachrichteninhalt: `<img src="invalid.jpg" onerror="alert('XSS')">`

**Testschritte:**

1. POST `/api/messages` mit obigen Testdaten
2. Öffne `/messages.html`
3. Öffne `/guest_messages.html?room_id=1`
4. Beobachte, ob Alert-Dialog erscheint

**Erwartetes Ergebnis:**
- KEIN Alert-Dialog wird angezeigt
- Nachricht wird als Text angezeigt (img-Tag nicht gerendert)
- Event-Handler wird nicht ausgeführt

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-ROOM-001: Belegten Raum nicht auf „available" setzen 🤖

**Priorität:** HOCH  
**Risiko:** R-ROOM-002  
**Akzeptanzkriterium:** AC-ROOM-004  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass ein Raum mit Status `occupied` nicht direkt auf `available` gesetzt werden kann.

**Voraussetzungen:**
- Mindestens ein Raum mit Status `occupied` existiert

**Testdaten:**
- Raum-ID: 1 (Raum 101, Status `occupied`)
- Neuer Status: `available`

**Testschritte:**

1. Hole aktuellen Raum-Status via GET `/api/rooms/1`
2. Prüfe, dass Status `occupied` ist
3. PATCH `/api/rooms/1/status` mit Body:
   ```json
   { "status": "available" }
   ```

**Erwartetes Ergebnis:**
- API gibt Fehler zurück (Status 409 Conflict)
- Fehlermeldung enthält Hinweis auf ungültigen Status-Übergang
- Raum-Status bleibt `occupied` (Verifikation via GET `/api/rooms/1`)

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-GUEST-001: Gast mit Zimmerzuweisung kann nicht gelöscht werden 🤖

**Priorität:** HOCH  
**Risiko:** R-GUEST-001  
**Akzeptanzkriterium:** AC-GUEST-005  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass ein Gast mit aktiver Zimmerzuweisung nicht gelöscht werden kann.

**Voraussetzungen:**
- Gast existiert und ist einem Raum zugewiesen

**Testdaten:**
- Gast-ID: 1 (Max Mustermann, Raum 101)
- Raum-ID: 1 (room_id != null)

**Testschritte:**

1. Hole Gast-Details via GET `/api/guests/1`
2. Prüfe, dass `room_id` nicht null ist
3. DELETE `/api/guests/1`

**Erwartetes Ergebnis:**
- API gibt Fehler zurück (Status 409 Conflict)
- Fehlermeldung enthält Hinweis auf aktive Zimmerzuweisung
- Gast existiert weiterhin (Verifikation via GET `/api/guests/1`)

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-CHECKIN-001: Gast kann nicht zweimal eingecheckt werden 🤖

**Priorität:** HOCH  
**Risiko:** R-CHECKIN-004  
**Akzeptanzkriterium:** AC-CHECKIN-003  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass ein Gast, der bereits einem Raum zugewiesen ist, nicht erneut eingecheckt werden kann.

**Voraussetzungen:**
- Gast ist bereits in Raum 101 eingecheckt
- Raum 102 ist verfügbar

**Testdaten:**
- Gast-ID: 1 (Max Mustermann, bereits in Raum 101)
- Ziel-Raum-ID: 2 (Raum 102, Status `available`)

**Testschritte:**

1. Hole Gast-Details via GET `/api/guests/1`
2. Prüfe, dass `room_id` bereits gesetzt ist (Raum 101)
3. Versuche erneuten Check-in: POST `/api/guests/1/checkin` mit Body:
   ```json
   { "room_id": 2 }
   ```

**Erwartetes Ergebnis:**
- API gibt Fehler zurück (Status 409 Conflict)
- Fehlermeldung enthält Hinweis, dass Gast bereits eingecheckt ist
- Gast bleibt Raum 101 zugewiesen (Verifikation via GET `/api/guests/1`)
- Raum 102 bleibt verfügbar

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-CHECKIN-002: Check-out setzt Raum auf „cleaning" 🤖

**Priorität:** HOCH  
**Risiko:** R-CHECKIN-002  
**Akzeptanzkriterium:** AC-CHECKIN-004  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass beim Check-out der Raum-Status auf `cleaning` gesetzt wird (nicht `available`).

**Voraussetzungen:**
- Gast ist in Raum 101 eingecheckt (Raum-Status `occupied`)

**Testdaten:**
- Gast-ID: 1 (Max Mustermann, Raum 101)
- Raum-ID: 1 (Raum 101, Status `occupied`)

**Testschritte:**

1. Hole Raum-Status via GET `/api/rooms/1`
2. Prüfe, dass Status `occupied` ist
3. Führe Check-out durch: POST `/api/guests/1/checkout`
4. Hole Gast-Details via GET `/api/guests/1`
5. Hole Raum-Status via GET `/api/rooms/1`

**Erwartetes Ergebnis:**
- Check-out erfolgreich (Status 200)
- Gast hat keine Zimmerzuweisung mehr (`room_id` ist null)
- Gast hat Check-out-Datum gesetzt
- **Raum hat Status `cleaning` (NICHT `available`)**

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

**Hinweis:** Dies ist der wichtigste API-Integrationstest für Decision 009.

---

## 3. Phase 2 — Funktionale Kern-Tests (Priorität: HOCH)

### TC-MSG-001: Nachricht erstellen und speichern 🤖

**Priorität:** HOCH  
**Risiko:** R-MSG-001  
**Akzeptanzkriterium:** AC-MSG-001, AC-MSG-003  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass eine Nachricht erstellt, gespeichert und mit korrekten Metadaten abgerufen werden kann.

**Voraussetzungen:**
- Mindestens ein Raum existiert (Raum 101)

**Testdaten:**
- Raum-ID: 1
- Sender: „Reception"
- Inhalt: „Welcome to our hotel!"

**Testschritte:**

1. POST `/api/messages` mit Body:
   ```json
   {
     "room_id": 1,
     "sender": "Reception",
     "content": "Welcome to our hotel!"
   }
   ```
2. Speichere zurückgegebene `message_id`
3. GET `/api/messages/{message_id}`

**Erwartetes Ergebnis:**
- POST gibt Status 201 zurück
- Nachricht enthält alle Metadaten: `id`, `sender`, `room_id`, `content`, `created_at`, `status`
- Status ist `sent` (initial)
- GET gibt dieselbe Nachricht zurück mit allen Metadaten

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-MSG-002: Nachricht bleibt nach Neustart verfügbar 🤖

**Priorität:** HOCH  
**Risiko:** R-MSG-001  
**Akzeptanzkriterium:** AC-MSG-013, AC-MSG-014  
**Testebene:** Integration (API) + System

**Ziel:**  
Sicherstellen, dass gespeicherte Nachrichten nach Anwendungsneustart weiterhin verfügbar sind.

**Voraussetzungen:**
- Anwendung läuft
- Mindestens ein Raum existiert

**Testdaten:**
- Raum-ID: 1
- Sender: „Reception"
- Inhalt: „Persistence test message"

**Testschritte:**

1. POST `/api/messages` mit obigen Testdaten
2. Speichere zurückgegebene `message_id`
3. **Stoppe Anwendung** (z. B. Docker Container stoppen)
4. **Starte Anwendung neu** (z. B. Docker Container starten)
5. GET `/api/messages/{message_id}`

**Erwartetes Ergebnis:**
- Nachricht ist nach Neustart weiterhin abrufbar
- Alle Metadaten sind unverändert (Sender, Inhalt, Zeitstempel, Status)

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

**Hinweis:** Dieser Test prüft SQLite-Persistenz.

---

### TC-MSG-003: Nachrichten nach Raum filtern 🤖

**Priorität:** HOCH  
**Risiko:** R-MSG-003  
**Akzeptanzkriterium:** AC-MSG-005  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass die Filterung nach Raum nur Nachrichten des gewünschten Raums zurückgibt.

**Voraussetzungen:**
- Mindestens zwei Räume existieren (Raum 101, Raum 102)

**Testdaten:**
- Nachricht 1: Raum 101, Inhalt „Message for room 101"
- Nachricht 2: Raum 102, Inhalt „Message for room 102"
- Nachricht 3: Raum 101, Inhalt „Another message for room 101"

**Testschritte:**

1. POST drei Nachrichten (siehe Testdaten)
2. GET `/api/messages?room_id=1` (Filter nach Raum 101)
3. Prüfe zurückgegebene Nachrichten
4. GET `/api/messages?room_id=2` (Filter nach Raum 102)
5. Prüfe zurückgegebene Nachrichten

**Erwartetes Ergebnis:**
- Filter `room_id=1` gibt 2 Nachrichten zurück (Nachricht 1 und 3)
- Filter `room_id=2` gibt 1 Nachricht zurück (Nachricht 2)
- Keine Nachrichten des jeweils anderen Raums werden angezeigt

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-MSG-004: Gast zeigt nur Nachrichten des eigenen Raums 🤖

**Priorität:** HOCH  
**Risiko:** R-MSG-003  
**Akzeptanzkriterium:** AC-MSG-007  
**Testebene:** E2E (UI)

**Ziel:**  
Sicherstellen, dass die Gastsicht nur Nachrichten des ausgewählten Raums anzeigt.

**Voraussetzungen:**
- Raum 101 und Raum 102 existieren
- Nachrichten für beide Räume existieren (siehe TC-MSG-003)

**Testdaten:**
- Raum 101 hat 2 Nachrichten
- Raum 102 hat 1 Nachricht

**Testschritte:**

1. Öffne `/guest_messages.html?room_id=1` (Raum 101)
2. Prüfe angezeigte Nachrichten in Tabelle
3. Öffne `/guest_messages.html?room_id=2` (Raum 102)
4. Prüfe angezeigte Nachrichten in Tabelle

**Erwartetes Ergebnis:**
- Gastsicht für Raum 101 zeigt 2 Nachrichten (nur für Raum 101)
- Gastsicht für Raum 102 zeigt 1 Nachricht (nur für Raum 102)
- Keine Nachrichten des jeweils anderen Raums werden angezeigt

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-MSG-005: Gast kann Nachrichten anderer Räume über URL-Parameter sehen 🧪

**Priorität:** HOCH  
**Risiko:** R-MSG-004 (Datenschutz)  
**Akzeptanzkriterium:** AC-MSG-007 (indirekt, Design-Limitation)  
**Testebene:** E2E (UI)

**Ziel:**  
Dokumentieren, dass die Gastsicht unauthenticated ist und Nachrichten beliebiger Räume angezeigt werden können (bekannte Design-Limitation).

**Voraussetzungen:**
- Raum 101 hat Nachricht „Private message for Room 101"
- Raum 102 existiert

**Testdaten:**
- Raum 101, Nachricht: „Private message for Room 101"
- Gast: angeblich in Raum 102

**Testschritte:**

1. Öffne `/guest_messages.html?room_id=1` (Raum 101, obwohl Gast angeblich in Raum 102 ist)
2. Prüfe, ob Nachricht „Private message for Room 101" angezeigt wird

**Erwartetes Ergebnis (basierend auf Design-Limitation):**
- Nachricht „Private message for Room 101" wird angezeigt
- Kein Authentifizierungs-Check verhindert Zugriff
- **Dies ist bekannte Design-Limitation (siehe Decision 008, Testbasis Abschnitt 6.2)**

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

**Hinweis:** Dies ist kein Bug, sondern dokumentierte Design-Limitation. Test dient zur Dokumentation des Risikos.

---

### TC-SEC-004: SQL-Injection in Raum-Filter 🧪

**Priorität:** HOCH  
**Risiko:** R-SEC-002  
**Akzeptanzkriterium:** AC-MSG-005 (indirekt, Sicherheit)  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass SQL-Injection-Versuche im Raum-Filter nicht zu Daten-Leakage führen.

**Voraussetzungen:**
- Mehrere Nachrichten für verschiedene Räume existieren

**Testdaten:**
- Manipulierter Raum-Filter: `1 OR 1=1`

**Testschritte:**

1. GET `/api/messages?room_id=1 OR 1=1`
2. Prüfe Anzahl zurückgegebener Nachrichten
3. Vergleiche mit GET `/api/messages` (alle Nachrichten)

**Erwartetes Ergebnis:**
- Kein SQL-Injection erfolgt
- Entweder: Filter wird als ungültig abgelehnt (Fehler)
- Oder: Filter gibt nur Nachrichten für Raum-ID 1 zurück (SQLAlchemy ORM schützt)
- NICHT: Alle Nachrichten werden zurückgegeben

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

**Hinweis:** Manueller Test empfohlen, da Sicherheitsprüfung.

---

### TC-SEC-005: SQL-Injection in Raum-Filter mit Kommentar 🧪

**Priorität:** HOCH  
**Risiko:** R-SEC-002  
**Akzeptanzkriterium:** AC-MSG-005 (indirekt)  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass SQL-Kommentar-Injection nicht zu Daten-Leakage führt.

**Voraussetzungen:**
- Mehrere Nachrichten existieren

**Testdaten:**
- Manipulierter Raum-Filter: `1--`

**Testschritte:**

1. GET `/api/messages?room_id=1--`
2. Prüfe Anzahl zurückgegebener Nachrichten

**Erwartetes Ergebnis:**
- Kein SQL-Injection erfolgt
- Entweder: Filter wird als ungültig abgelehnt
- Oder: Filter gibt nur Nachrichten für Raum-ID 1 zurück

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-SEC-006: Sender-Impersonation — Gast sendet als „Reception" 🧪

**Priorität:** HOCH  
**Risiko:** R-SEC-003  
**Akzeptanzkriterium:** NA-003 (nicht ableitbar, aber Risiko dokumentiert)  
**Testebene:** Integration (API)

**Ziel:**  
Dokumentieren, dass das Sender-Feld Freitext ist und Impersonation möglich ist (bekannte Design-Limitation).

**Voraussetzungen:**
- Raum 101 existiert

**Testdaten:**
- Raum-ID: 1
- Sender: „Reception" (obwohl von Gast gesendet)
- Inhalt: „Fake message from Reception"

**Testschritte:**

1. POST `/api/messages` mit obigen Testdaten (Sender „Reception")
2. GET `/api/messages?room_id=1`
3. Prüfe, ob Nachricht mit Sender „Reception" gespeichert wurde

**Erwartetes Ergebnis (basierend auf Design-Limitation):**
- Nachricht wird akzeptiert und gespeichert
- Sender ist „Reception" (obwohl von Gast gesendet)
- Kein Authentifizierungs-Check verhindert Impersonation
- **Dies ist bekannte Design-Limitation (siehe Decision 006, Testbasis Abschnitt 6.2)**

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

**Hinweis:** Dies ist kein Bug, sondern dokumentierte Design-Limitation. Test dient zur Dokumentation des Risikos.

---

## 4. Phase 3 — Positive Akzeptanztests (Priorität: MITTEL)

### TC-ROOM-002: Räume auflisten 🤖

**Priorität:** MITTEL  
**Akzeptanzkriterium:** AC-ROOM-001  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass alle Räume mit Raumnummer, Kategorie und Status aufgelistet werden.

**Voraussetzungen:**
- Mindestens 3 Räume existieren (z. B. aus Seed-Daten)

**Testdaten:**
- Erwartete Räume: Raum 101, 102, 103 (mindestens)

**Testschritte:**

1. GET `/api/rooms`
2. Prüfe Anzahl zurückgegebener Räume
3. Prüfe, dass jeder Raum Attribute hat: `id`, `number`, `category`, `status`

**Erwartetes Ergebnis:**
- Mindestens 3 Räume werden zurückgegeben
- Jeder Raum enthält `id`, `number`, `category`, `status`
- Status ist einer von: `available`, `occupied`, `cleaning`

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-ROOM-003: Einzelnen Raum anzeigen 🤖

**Priorität:** MITTEL  
**Akzeptanzkriterium:** AC-ROOM-002  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass Details eines einzelnen Raums abgerufen werden können.

**Voraussetzungen:**
- Raum 101 existiert

**Testdaten:**
- Raum-ID: 1 (Raum 101)

**Testschritte:**

1. GET `/api/rooms/1`
2. Prüfe zurückgegebene Raum-Details

**Erwartetes Ergebnis:**
- Status 200
- Raum-Details enthalten: `id`, `number`, `category`, `status`
- Raumnummer ist „101"

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-ROOM-004: Raumstatus von „cleaning" auf „available" ändern 🤖

**Priorität:** MITTEL  
**Akzeptanzkriterium:** AC-ROOM-005  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass ein Raum nach Reinigung auf „available" gesetzt werden kann.

**Voraussetzungen:**
- Raum 101 hat Status `cleaning`

**Testdaten:**
- Raum-ID: 1 (Raum 101, Status `cleaning`)
- Neuer Status: `available`

**Testschritte:**

1. Hole aktuellen Status: GET `/api/rooms/1`
2. Prüfe, dass Status `cleaning` ist
3. PATCH `/api/rooms/1/status` mit Body:
   ```json
   { "status": "available" }
   ```
4. Hole aktuellen Status: GET `/api/rooms/1`

**Erwartetes Ergebnis:**
- PATCH gibt Status 200 zurück
- Raum-Status ist `available`

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-GUEST-002: Gast anlegen 🤖

**Priorität:** MITTEL  
**Akzeptanzkriterium:** AC-GUEST-001  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass ein neuer Gast mit Vorname und Nachname angelegt werden kann.

**Voraussetzungen:**
- Keine

**Testdaten:**
- Vorname: „Maria"
- Nachname: „Schmidt"

**Testschritte:**

1. POST `/api/guests` mit Body:
   ```json
   {
     "first_name": "Maria",
     "last_name": "Schmidt"
   }
   ```
2. Speichere zurückgegebene `guest_id`
3. GET `/api/guests/{guest_id}`

**Erwartetes Ergebnis:**
- POST gibt Status 201 zurück
- Gast hat eindeutige `id`
- GET gibt Gast mit Vorname „Maria" und Nachname „Schmidt" zurück
- `room_id`, `check_in_date`, `check_out_date` sind null

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-GUEST-003: Alle Gäste auflisten 🤖

**Priorität:** MITTEL  
**Akzeptanzkriterium:** AC-GUEST-002  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass alle Gäste aufgelistet werden.

**Voraussetzungen:**
- Mindestens 2 Gäste existieren

**Testdaten:**
- Erwartete Gäste: mindestens 2

**Testschritte:**

1. GET `/api/guests`
2. Prüfe Anzahl zurückgegebener Gäste
3. Prüfe Attribute jedes Gastes

**Erwartetes Ergebnis:**
- Mindestens 2 Gäste werden zurückgegeben
- Jeder Gast enthält: `id`, `first_name`, `last_name`, `room_id`, `check_in_date`, `check_out_date`

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-GUEST-004: Gast bearbeiten 🤖

**Priorität:** MITTEL  
**Akzeptanzkriterium:** AC-GUEST-003  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass Vorname und Nachname eines Gastes geändert werden können.

**Voraussetzungen:**
- Gast existiert (z. B. „Maria Schmidt" aus TC-GUEST-002)

**Testdaten:**
- Gast-ID: (aus TC-GUEST-002)
- Neuer Vorname: „Maria-Luise"
- Nachname bleibt: „Schmidt"

**Testschritte:**

1. PUT `/api/guests/{guest_id}` mit Body:
   ```json
   {
     "first_name": "Maria-Luise",
     "last_name": "Schmidt"
   }
   ```
2. GET `/api/guests/{guest_id}`

**Erwartetes Ergebnis:**
- PUT gibt Status 200 zurück
- GET gibt Gast mit Vorname „Maria-Luise" zurück
- Nachname bleibt „Schmidt"

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-GUEST-005: Gast ohne Zimmerzuweisung löschen 🤖

**Priorität:** MITTEL  
**Akzeptanzkriterium:** AC-GUEST-004  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass ein Gast ohne Zimmerzuweisung gelöscht werden kann.

**Voraussetzungen:**
- Gast ohne Zimmerzuweisung existiert (`room_id` ist null)

**Testdaten:**
- Gast-ID: (aus TC-GUEST-002, falls nicht eingecheckt)

**Testschritte:**

1. Hole Gast-Details: GET `/api/guests/{guest_id}`
2. Prüfe, dass `room_id` null ist
3. DELETE `/api/guests/{guest_id}`
4. Versuche Gast abzurufen: GET `/api/guests/{guest_id}`

**Erwartetes Ergebnis:**
- DELETE gibt Status 204 (No Content) zurück
- GET gibt Status 404 (Not Found) zurück

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-GUEST-006: Umlaute in Gastnamen werden gespeichert 🤖

**Priorität:** MITTEL (Regressionstest)  
**Risiko:** R-GUEST-002  
**Akzeptanzkriterium:** AC-GUEST-006  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass Umlaute und Sonderzeichen in Gast-Namen korrekt gespeichert werden.

**Voraussetzungen:**
- Keine

**Testdaten:**
- Vorname: „Jörg"
- Nachname: „Müller"

**Testschritte:**

1. POST `/api/guests` mit Body:
   ```json
   {
     "first_name": "Jörg",
     "last_name": "Müller"
   }
   ```
2. Speichere zurückgegebene `guest_id`
3. GET `/api/guests/{guest_id}`

**Erwartetes Ergebnis:**
- POST gibt Status 201 zurück
- GET gibt Gast mit Vorname „Jörg" (nicht „Jrg") und Nachname „Müller" (nicht „Mller") zurück
- Umlaute sind unverändert

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-CHECKIN-003: Gast einem verfügbaren Raum zuweisen 🤖

**Priorität:** MITTEL  
**Akzeptanzkriterium:** AC-CHECKIN-001  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass ein Gast einem verfügbaren Raum zugewiesen werden kann und Check-in-Datum gespeichert wird.

**Voraussetzungen:**
- Gast ohne Zimmerzuweisung existiert
- Raum mit Status `available` existiert

**Testdaten:**
- Gast-ID: 1 (ohne Zimmerzuweisung)
- Raum-ID: 1 (Raum 101, Status `available`)

**Testschritte:**

1. Hole Gast-Details: GET `/api/guests/1` (prüfe `room_id` ist null)
2. Hole Raum-Details: GET `/api/rooms/1` (prüfe Status `available`)
3. POST `/api/guests/1/checkin` mit Body:
   ```json
   { "room_id": 1 }
   ```
4. Hole Gast-Details: GET `/api/guests/1`
5. Hole Raum-Details: GET `/api/rooms/1`

**Erwartetes Ergebnis:**
- POST gibt Status 200 zurück
- Gast hat `room_id` = 1
- Gast hat `check_in_date` gesetzt (heutiges Datum)
- Raum hat Status `occupied`

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-CHECKIN-004: Check-in in belegten Raum wird abgelehnt 🤖

**Priorität:** MITTEL  
**Akzeptanzkriterium:** AC-CHECKIN-002  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass ein Check-in in einen Raum mit Status `occupied` abgelehnt wird.

**Voraussetzungen:**
- Gast ohne Zimmerzuweisung existiert
- Raum mit Status `occupied` existiert

**Testdaten:**
- Gast-ID: 2 (ohne Zimmerzuweisung)
- Raum-ID: 1 (Raum 101, Status `occupied`)

**Testschritte:**

1. Hole Raum-Details: GET `/api/rooms/1` (prüfe Status `occupied`)
2. POST `/api/guests/2/checkin` mit Body:
   ```json
   { "room_id": 1 }
   ```

**Erwartetes Ergebnis:**
- API gibt Status 409 (Conflict) zurück
- Fehlermeldung enthält Hinweis, dass Raum nicht verfügbar ist
- Gast bleibt ohne Zimmerzuweisung

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-CHECKIN-005: Check-in in Raum mit Status „cleaning" wird abgelehnt 🤖

**Priorität:** MITTEL  
**Akzeptanzkriterium:** AC-CHECKIN-002, AC-CHECKIN-006  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass ein Check-in in einen Raum mit Status `cleaning` abgelehnt wird.

**Voraussetzungen:**
- Gast ohne Zimmerzuweisung existiert
- Raum mit Status `cleaning` existiert

**Testdaten:**
- Gast-ID: 2
- Raum-ID: 1 (Status `cleaning`)

**Testschritte:**

1. Setze Raum auf Status `cleaning` (falls nötig via PATCH `/api/rooms/1/status`)
2. POST `/api/guests/2/checkin` mit Body:
   ```json
   { "room_id": 1 }
   ```

**Erwartetes Ergebnis:**
- API gibt Status 409 (Conflict) zurück
- Fehlermeldung enthält Hinweis, dass Raum nicht verfügbar ist
- Gast bleibt ohne Zimmerzuweisung

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-CHECKIN-006: Check-out entfernt Zimmerzuweisung 🤖

**Priorität:** MITTEL  
**Akzeptanzkriterium:** AC-CHECKIN-004  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass beim Check-out die Zimmerzuweisung entfernt und das Check-out-Datum gespeichert wird.

**Voraussetzungen:**
- Gast ist einem Raum zugewiesen

**Testdaten:**
- Gast-ID: 1 (in Raum 101 eingecheckt)

**Testschritte:**

1. Hole Gast-Details: GET `/api/guests/1` (prüfe `room_id` ist gesetzt)
2. POST `/api/guests/1/checkout`
3. Hole Gast-Details: GET `/api/guests/1`

**Erwartetes Ergebnis:**
- POST gibt Status 200 zurück
- Gast hat `room_id` = null
- Gast hat `check_out_date` gesetzt (heutiges Datum)

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-CHECKIN-007: Check-out für Gast ohne Zimmerzuweisung wird abgelehnt 🤖

**Priorität:** MITTEL  
**Akzeptanzkriterium:** AC-CHECKIN-005  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass ein Check-out für einen Gast ohne Zimmerzuweisung abgelehnt wird.

**Voraussetzungen:**
- Gast ohne Zimmerzuweisung existiert

**Testdaten:**
- Gast-ID: 2 (`room_id` ist null)

**Testschritte:**

1. Hole Gast-Details: GET `/api/guests/2` (prüfe `room_id` ist null)
2. POST `/api/guests/2/checkout`

**Erwartetes Ergebnis:**
- API gibt Status 409 (Conflict) zurück
- Fehlermeldung enthält Hinweis, dass Gast nicht eingecheckt ist

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-MSG-006: Alle Nachrichten anzeigen 🤖

**Priorität:** MITTEL  
**Akzeptanzkriterium:** AC-MSG-004  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass alle Nachrichten mit Metadaten aufgelistet werden.

**Voraussetzungen:**
- Mindestens 3 Nachrichten existieren

**Testdaten:**
- Erwartete Nachrichten: mindestens 3

**Testschritte:**

1. GET `/api/messages`
2. Prüfe Anzahl zurückgegebener Nachrichten
3. Prüfe Attribute jeder Nachricht

**Erwartetes Ergebnis:**
- Mindestens 3 Nachrichten werden zurückgegeben
- Jede Nachricht enthält: `id`, `sender`, `room_id`, `content`, `created_at`, `status`

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-MSG-007: Nachrichtenstatus ist sichtbar 🤖

**Priorität:** MITTEL  
**Akzeptanzkriterium:** AC-MSG-008  
**Testebene:** E2E (UI)

**Ziel:**  
Sicherstellen, dass der Nachrichtenstatus in der UI sichtbar ist.

**Voraussetzungen:**
- Nachricht mit Status `sent` existiert

**Testdaten:**
- Nachricht mit bekannter ID und Status `sent`

**Testschritte:**

1. Öffne `/messages.html` (Rezeptionsansicht)
2. Finde Nachricht in Tabelle
3. Prüfe Status-Anzeige

**Erwartetes Ergebnis:**
- Status „sent" ist als Badge oder Text sichtbar angezeigt

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-MSG-008: Nachrichtenstatus von „sent" zu „delivered" ändern 🤖

**Priorität:** MITTEL  
**Akzeptanzkriterium:** AC-MSG-011  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass der Status einer Nachricht von `sent` zu `delivered` geändert werden kann.

**Voraussetzungen:**
- Nachricht mit Status `sent` existiert

**Testdaten:**
- Nachricht-ID: (aus TC-MSG-001)
- Aktueller Status: `sent`
- Neuer Status: `delivered`

**Testschritte:**

1. Hole Nachricht: GET `/api/messages/{message_id}` (prüfe Status `sent`)
2. PATCH `/api/messages/{message_id}/status` mit Body:
   ```json
   { "status": "delivered" }
   ```
3. Hole Nachricht: GET `/api/messages/{message_id}`

**Erwartetes Ergebnis:**
- PATCH gibt Status 200 zurück
- Nachricht hat Status `delivered`

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-MSG-009: Nachrichtenstatus von „delivered" zu „read" ändern 🤖

**Priorität:** MITTEL  
**Akzeptanzkriterium:** AC-MSG-012  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass der Status einer Nachricht von `delivered` zu `read` geändert werden kann.

**Voraussetzungen:**
- Nachricht mit Status `delivered` existiert

**Testdaten:**
- Nachricht-ID: (aus TC-MSG-008)
- Aktueller Status: `delivered`
- Neuer Status: `read`

**Testschritte:**

1. Hole Nachricht: GET `/api/messages/{message_id}` (prüfe Status `delivered`)
2. PATCH `/api/messages/{message_id}/status` mit Body:
   ```json
   { "status": "read" }
   ```
3. Hole Nachricht: GET `/api/messages/{message_id}`

**Erwartetes Ergebnis:**
- PATCH gibt Status 200 zurück
- Nachricht hat Status `read`

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

## 5. Phase 4 — Erweiterte Tests (Priorität: MITTEL / NIEDRIG)

### TC-MSG-010: Nachrichtenstatus Rückwärts-Änderung wird abgelehnt 🤖

**Priorität:** MITTEL  
**Risiko:** R-MSG-002  
**Akzeptanzkriterium:** AC-MSG-010  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass Rückwärts-Status-Änderungen (z. B. `delivered → sent`) abgelehnt werden.

**Voraussetzungen:**
- Nachricht mit Status `delivered` existiert

**Testdaten:**
- Nachricht-ID: (aus TC-MSG-008)
- Aktueller Status: `delivered`
- Ungültiger neuer Status: `sent` (Rückwärts)

**Testschritte:**

1. Hole Nachricht: GET `/api/messages/{message_id}` (prüfe Status `delivered`)
2. PATCH `/api/messages/{message_id}/status` mit Body:
   ```json
   { "status": "sent" }
   ```

**Erwartetes Ergebnis:**
- API gibt Status 409 (Conflict) zurück
- Fehlermeldung enthält Hinweis auf ungültigen Status-Übergang
- Status bleibt `delivered`

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-MSG-011: Nachrichtenstatus Überspringen wird abgelehnt 🤖

**Priorität:** MITTEL  
**Risiko:** R-MSG-002  
**Akzeptanzkriterium:** AC-MSG-010  
**Testebene:** Integration (API)

**Ziel:**  
Sicherstellen, dass Status-Übergänge mit Überspringen (z. B. `sent → read`) abgelehnt werden.

**Voraussetzungen:**
- Nachricht mit Status `sent` existiert

**Testdaten:**
- Nachricht-ID: (neu erstellen)
- Aktueller Status: `sent`
- Ungültiger neuer Status: `read` (Überspringen von `delivered`)

**Testschritte:**

1. POST `/api/messages` (neue Nachricht, Status `sent`)
2. PATCH `/api/messages/{message_id}/status` mit Body:
   ```json
   { "status": "read" }
   ```

**Erwartetes Ergebnis:**
- API gibt Status 409 (Conflict) zurück
- Fehlermeldung enthält Hinweis auf ungültigen Status-Übergang
- Status bleibt `sent`

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

---

### TC-CHECKIN-008: Mehrfach-Check-in bei gleichzeitigen Anfragen (Concurrency) 🧪

**Priorität:** HOCH (aber aufwändig)  
**Risiko:** R-CHECKIN-001  
**Akzeptanzkriterium:** AC-CHECKIN-001, AC-CHECKIN-002  
**Testebene:** Integration (API) — Concurrency-Test

**Ziel:**  
Sicherstellen, dass bei gleichzeitigen Check-ins in denselben Raum nur ein Check-in erfolgreich ist.

**Voraussetzungen:**
- Raum mit Status `available` existiert
- Zwei Gäste ohne Zimmerzuweisung existieren

**Testdaten:**
- Raum-ID: 1 (Status `available`)
- Gast-ID 1: Max Mustermann
- Gast-ID 2: Erika Musterfrau

**Testschritte:**

1. Starte zwei parallele API-Requests:
   - Thread 1: POST `/api/guests/1/checkin` mit `{ "room_id": 1 }`
   - Thread 2: POST `/api/guests/2/checkin` mit `{ "room_id": 1 }`
2. Warte auf beide Antworten
3. GET `/api/guests/1` und GET `/api/guests/2`
4. GET `/api/rooms/1`

**Erwartetes Ergebnis:**
- Einer der beiden Check-ins gibt Status 200 zurück (erfolgreich)
- Der andere Check-in gibt Status 409 zurück (Raum nicht mehr verfügbar)
- Nur ein Gast ist dem Raum zugewiesen
- Raum hat Status `occupied`

**Tatsächliches Ergebnis:** _(wird beim Testdurchlauf ausgefüllt)_

**Status:** _(Bestanden / Fehlgeschlagen / Blockiert)_

**Hinweis:** Manueller Test mit speziellem Tool (z. B. Thread-basierte Test-Infrastruktur) erforderlich.

---

## 6. Zusammenfassung

**Gesamt-Anzahl Testfälle:** 37

**Nach Priorität:**
- **KRITISCH:** 3 (XSS-Tests)
- **HOCH:** 11 (Datenintegrität, Persistenz, Filter, Sicherheit)
- **MITTEL:** 22 (Positive Akzeptanztests, Regressionstests)
- **NIEDRIG:** 1 (Concurrency-Test)

**Nach Testebene:**
- **Unit:** 0 (Unit-Tests auf Code-Ebene separat zu entwickeln)
- **Integration (API):** 32
- **E2E (UI):** 5

**Automatisierungskandidaten (🤖):** 31  
**Manuelle Tests (🧪):** 6 (Sicherheitstests, Concurrency-Test)

**Empfohlene Testdurchführungs-Reihenfolge:**

1. **Phase 1 — Kritische Tests** (TC-SEC-001 bis TC-CHECKIN-002): Sofort durchführen
2. **Phase 2 — Funktionale Kern-Tests** (TC-MSG-001 bis TC-SEC-006): Nächste Priorität
3. **Phase 3 — Positive Akzeptanztests** (TC-ROOM-002 bis TC-MSG-009): Vollständige Abdeckung
4. **Phase 4 — Erweiterte Tests** (TC-MSG-010 bis TC-CHECKIN-008): Bei Bedarf

---

**Ende der Testfälle**
