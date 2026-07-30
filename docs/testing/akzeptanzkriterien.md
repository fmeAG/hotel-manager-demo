# Akzeptanzkriterien: Hotel-Management-Anwendung mit Messaging

**Erstellungsdatum:** 2026-07-30  
**Projektstand:** Version 1.4.0  
**Basis:** `docs/testing/testbasis.md`

---

## 1. Übersicht

Dieses Dokument beschreibt die Akzeptanzkriterien für die Hotel-Management-Anwendung. Die Kriterien wurden ausschließlich aus belegten fachlichen Anforderungen abgeleitet.

**Struktur der IDs:**
- **AC-ROOM-NNN:** Raum-Management
- **AC-GUEST-NNN:** Gäste-Management
- **AC-CHECKIN-NNN:** Check-in / Check-out
- **AC-MSG-NNN:** Messaging (Rezeption und Gast)

---

## 2. Raum-Management

### AC-ROOM-001: Räume auflisten

**Anforderung:** Rezeptionspersonal muss in der Lage sein, alle Räume aufzulisten.

**Quelle:** 
- `specs/basis_spec.md` (Zeile 56: „List rooms")
- `docs/testing/testbasis.md` (Abschnitt 4.1)

**Gegeben** ein Hotel mit mehreren Räumen existiert.

**Wenn** das Rezeptionspersonal die Liste aller Räume aufruft.

**Dann** werden alle vorhandenen Räume mit Raumnummer, Kategorie und Status angezeigt.

**Offene Bezüge:**
- Keine

---

### AC-ROOM-002: Einzelnen Raum anzeigen

**Anforderung:** Rezeptionspersonal muss in der Lage sein, Details eines einzelnen Raums anzuzeigen.

**Quelle:** 
- `specs/basis_spec.md` (Zeile 57: „View room details")
- `docs/testing/testbasis.md` (Abschnitt 4.1)

**Gegeben** ein Raum mit bekannter Raumnummer existiert.

**Wenn** das Rezeptionspersonal die Details dieses Raums aufruft.

**Dann** werden Raumnummer, Kategorie und aktueller Status des Raums angezeigt.

**Offene Bezüge:**
- Keine

---

### AC-ROOM-003: Raumstatus ändern (allgemein)

**Anforderung:** Rezeptionspersonal muss in der Lage sein, den Raumstatus zu ändern.

**Quelle:** 
- `specs/basis_spec.md` (Zeile 58: „Change room status")
- `docs/testing/testbasis.md` (Abschnitt 4.1)

**Gegeben** ein Raum mit einem bestimmten Status existiert.

**Wenn** das Rezeptionspersonal den Status dieses Raums auf einen zulässigen anderen Status ändert.

**Dann** wird der neue Status für den Raum gespeichert und angezeigt.

**Offene Bezüge:**
- Siehe AC-ROOM-004 für Einschränkung bei Status `occupied`

---

### AC-ROOM-004: Belegter Raum kann nur auf „cleaning" gesetzt werden

**Anforderung:** Ein belegter Raum kann nicht direkt auf „verfügbar" gesetzt werden; er muss zunächst gereinigt werden.

**Quelle:** 
- `docs/decisions.md` (Decision 009: „occupied rooms can only be changed to cleaning status")
- `docs/testing/testbasis.md` (Abschnitt 7.1)

**Gegeben** ein Raum hat den Status `occupied`.

**Wenn** das Rezeptionspersonal versucht, den Status des Raums auf `available` zu ändern.

**Dann** wird die Änderung abgelehnt.

**Offene Bezüge:**
- Keine

---

### AC-ROOM-005: Raum nach Reinigung auf „available" setzen

**Anforderung:** Ein Raum im Status „cleaning" kann auf „available" gesetzt werden.

**Quelle:** 
- `specs/basis_spec.md` (Zeile 98: „Mark the room as available only after cleaning is complete")
- `docs/testing/testbasis.md` (Abschnitt 7.1)

**Gegeben** ein Raum hat den Status `cleaning`.

**Wenn** das Rezeptionspersonal den Status des Raums auf `available` ändert.

**Dann** wird der Raum auf `available` gesetzt und ist für Check-ins verfügbar.

**Offene Bezüge:**
- Frage 3 (Testbasis Abschnitt 9.1): Wer darf einen Raum von `cleaning` auf `available` setzen?

---

## 3. Gäste-Management

### AC-GUEST-001: Gast anlegen

**Anforderung:** Rezeptionspersonal muss in der Lage sein, einen neuen Gast mit Vorname und Nachname anzulegen.

**Quelle:** 
- `specs/basis_spec.md` (Zeile 74: „Create guests")
- `docs/testing/testbasis.md` (Abschnitt 4.2)

**Gegeben** das Rezeptionspersonal hat Vorname und Nachname eines neuen Gastes.

**Wenn** das Rezeptionspersonal einen Gast mit diesen Daten anlegt.

**Dann** wird der Gast mit Vorname und Nachname im System gespeichert und erhält eine eindeutige Kennung.

**Offene Bezüge:**
- Frage 4 (Testbasis Abschnitt 9.2): Welche Zeichen sind in Gast-Namen erlaubt? Gibt es Längenbeschränkungen?

---

### AC-GUEST-002: Alle Gäste auflisten

**Anforderung:** Rezeptionspersonal muss in der Lage sein, alle Gäste anzuzeigen.

**Quelle:** 
- `specs/basis_spec.md` (Zeile 75: „View guests")
- `docs/testing/testbasis.md` (Abschnitt 4.2)

**Gegeben** mehrere Gäste sind im System vorhanden.

**Wenn** das Rezeptionspersonal die Liste aller Gäste aufruft.

**Dann** werden alle Gäste mit Vorname, Nachname, Zimmerzuweisung, Check-in-Datum und Check-out-Datum angezeigt.

**Offene Bezüge:**
- Keine

---

### AC-GUEST-003: Gast bearbeiten

**Anforderung:** Rezeptionspersonal muss in der Lage sein, Vorname und Nachname eines Gastes zu ändern.

**Quelle:** 
- `specs/basis_spec.md` (Zeile 76: „Update guests")
- `docs/testing/testbasis.md` (Abschnitt 4.2)

**Gegeben** ein Gast mit bekannter Kennung existiert.

**Wenn** das Rezeptionspersonal Vorname oder Nachname dieses Gastes ändert.

**Dann** werden die neuen Daten für den Gast gespeichert und angezeigt.

**Offene Bezüge:**
- Frage 4 (Testbasis Abschnitt 9.2): Welche Zeichen sind in Gast-Namen erlaubt?

---

### AC-GUEST-004: Gast ohne Zimmerzuweisung löschen

**Anforderung:** Rezeptionspersonal muss in der Lage sein, Gäste zu löschen.

**Quelle:** 
- `specs/basis_spec.md` (Zeile 77: „Delete guests")
- `docs/testing/testbasis.md` (Abschnitt 4.2)

**Gegeben** ein Gast ohne aktive Zimmerzuweisung existiert.

**Wenn** das Rezeptionspersonal diesen Gast löscht.

**Dann** wird der Gast aus dem System entfernt.

**Offene Bezüge:**
- Frage 5 (Testbasis Abschnitt 9.2): Ist das Löschen von Gästen ohne Raumzuweisung fachlich korrekt? Was passiert mit historischen Check-in/out-Daten?

---

### AC-GUEST-005: Gast mit Zimmerzuweisung kann nicht gelöscht werden

**Anforderung:** Ein Gast mit aktiver Zimmerzuweisung kann nicht gelöscht werden.

**Quelle:** 
- `docs/testing/testbasis.md` (Abschnitt 4.2, Geschäftsregel Löschen)
- `docs/api.md` (Zeilen 106-108)

**Gegeben** ein Gast hat eine aktive Zimmerzuweisung.

**Wenn** das Rezeptionspersonal versucht, diesen Gast zu löschen.

**Dann** wird die Löschung abgelehnt.

**Offene Bezüge:**
- Keine

---

### AC-GUEST-006: Umlaute in Gastnamen werden gespeichert

**Anforderung:** Gast-Namen mit Umlauten und Sonderzeichen sollen korrekt gespeichert werden.

**Quelle:** 
- `docs/decisions.md` (Decision 007: „Guest names are persisted as received")
- `docs/testing/testbasis.md` (Abschnitt 4.2, Zeichensatz-Behandlung)

**Gegeben** das Rezeptionspersonal legt einen Gast mit Umlauten im Namen an (z. B. „Jörg Müller").

**Wenn** der Gast gespeichert wird.

**Dann** werden die Umlaute korrekt gespeichert und bei Abruf unverändert angezeigt (z. B. „Jörg Müller", nicht „Jrg Mller").

**Offene Bezüge:**
- Keine

---

## 4. Check-in / Check-out

### AC-CHECKIN-001: Gast einem verfügbaren Raum zuweisen

**Anforderung:** Rezeptionspersonal muss in der Lage sein, einen Gast einem Raum zuzuweisen und das Check-in-Datum zu speichern.

**Quelle:** 
- `specs/basis_spec.md` (Zeilen 85-87: „Assign a room to a guest, Mark the room as occupied, Store check-in date")
- `docs/testing/testbasis.md` (Abschnitt 4.3)

**Gegeben** ein Gast ohne Zimmerzuweisung und ein Raum mit Status `available` existieren.

**Wenn** das Rezeptionspersonal den Gast diesem Raum zuweist.

**Dann** wird der Gast dem Raum zugewiesen, der Raum-Status wird auf `occupied` gesetzt, und das Check-in-Datum wird gespeichert.

**Offene Bezüge:**
- Frage 6 (Testbasis Abschnitt 9.3): In welcher Zeitzone werden Check-in-Daten gespeichert?

---

### AC-CHECKIN-002: Check-in nur für verfügbare Räume

**Anforderung:** Ein Gast kann nur einem Raum mit Status „available" zugewiesen werden.

**Quelle:** 
- `docs/testing/testbasis.md` (Abschnitt 4.3, Geschäftsregeln Check-in)
- `app/services/checkinout_service.py` (Zeilen 18-19)

**Gegeben** ein Raum hat nicht den Status `available` (z. B. `occupied` oder `cleaning`).

**Wenn** das Rezeptionspersonal versucht, einen Gast diesem Raum zuzuweisen.

**Dann** wird der Check-in abgelehnt.

**Offene Bezüge:**
- Keine

---

### AC-CHECKIN-003: Gast kann nur einem Raum zugewiesen sein

**Anforderung:** Ein Gast kann zu einem Zeitpunkt höchstens einem Raum zugewiesen sein.

**Quelle:** 
- `docs/testing/testbasis.md` (Abschnitt 7.2, Anforderung Gast-Zimmerzuweisung)
- `app/services/checkinout_service.py` (Zeilen 12-13)

**Gegeben** ein Gast ist bereits einem Raum zugewiesen.

**Wenn** das Rezeptionspersonal versucht, diesen Gast einem anderen Raum zuzuweisen.

**Dann** wird der Check-in abgelehnt.

**Offene Bezüge:**
- Frage 7 (Testbasis Abschnitt 9.3): Ist ein direkter Check-in in einen anderen Raum ohne vorherigen Check-out erlaubt (Zimmerwechsel)?

---

### AC-CHECKIN-004: Check-out entfernt Zimmerzuweisung und setzt Raum auf „cleaning"

**Anforderung:** Beim Check-out wird die Zimmerzuweisung entfernt, der Raum auf „cleaning" gesetzt, und das Check-out-Datum gespeichert.

**Quelle:** 
- `specs/basis_spec.md` (Zeilen 95-97: „Remove room assignment, Mark room as cleaning, Store check-out date")
- `docs/testing/testbasis.md` (Abschnitt 7.1, Raum-Status-Lifecycle)
- `docs/decisions.md` (Decision 009)

**Gegeben** ein Gast ist einem Raum zugewiesen.

**Wenn** das Rezeptionspersonal den Check-out für diesen Gast durchführt.

**Dann** wird die Zimmerzuweisung entfernt, der Raum-Status wird auf `cleaning` gesetzt, und das Check-out-Datum wird gespeichert.

**Offene Bezüge:**
- Frage 6 (Testbasis Abschnitt 9.3): In welcher Zeitzone werden Check-out-Daten gespeichert?

---

### AC-CHECKIN-005: Check-out nur für eingecheckte Gäste

**Anforderung:** Ein Gast ohne aktive Zimmerzuweisung kann nicht ausgecheckt werden.

**Quelle:** 
- `docs/testing/testbasis.md` (Abschnitt 4.3, Geschäftsregeln Check-out)
- `app/services/checkinout_service.py` (Zeilen 29-30)

**Gegeben** ein Gast hat keine Zimmerzuweisung.

**Wenn** das Rezeptionspersonal versucht, diesen Gast auszuchecken.

**Dann** wird der Check-out abgelehnt.

**Offene Bezüge:**
- Frage 8 (Testbasis Abschnitt 9.3): Was passiert, wenn ein Gast manuell `room_id = null` gesetzt bekommt?

---

### AC-CHECKIN-006: Raum nach Check-out nicht sofort für Check-in verfügbar

**Anforderung:** Ein Raum, der nach einem Check-out auf „cleaning" gesetzt wurde, kann erst wieder eingecheckt werden, nachdem er auf „available" gesetzt wurde.

**Quelle:** 
- `specs/basis_spec.md` (Zeile 98: „Mark the room as available only after cleaning is complete")
- `docs/testing/testbasis.md` (Abschnitt 7.1, Raum-Status-Lifecycle)

**Gegeben** ein Check-out wurde durchgeführt und der Raum-Status ist `cleaning`.

**Wenn** das Rezeptionspersonal versucht, einen neuen Gast diesem Raum zuzuweisen.

**Dann** wird der Check-in abgelehnt (da Raum nicht `available` ist).

**Offene Bezüge:**
- Keine

---

## 5. Messaging — Nachrichten erstellen und senden

### AC-MSG-001: Rezeption erstellt Nachricht an einen Raum

**Anforderung:** Rezeptionspersonal soll in der Lage sein, eine Nachricht zu erstellen, einen Zielraum auszuwählen, einen Text einzugeben und die Nachricht zu senden.

**Quelle:** 
- `specs/chat_feature_spec.md` (Zeilen 28-31: „Create a message, Select a target room, Enter a message text, Send the message")
- `docs/testing/testbasis.md` (Abschnitt 4.4)

**Gegeben** ein Raum existiert und das Rezeptionspersonal hat einen Nachrichtentext verfasst.

**Wenn** das Rezeptionspersonal die Nachricht an diesen Raum sendet.

**Dann** wird die Nachricht mit Absender, Zielraum, Inhalt, Zeitstempel und Status `sent` gespeichert und erhält eine eindeutige Kennung.

**Offene Bezüge:**
- Frage 9 (Testbasis Abschnitt 9.4): Darf eine Nachricht an einen Raum ohne aktiven Gast gesendet werden?
- Frage 12 (Testbasis Abschnitt 9.4): Ist „Reception" ein vorgegebener Wert oder darf der Mitarbeiter seinen Namen eingeben?

---

### AC-MSG-002: Nachricht enthält Metadaten

**Anforderung:** Jede Nachricht soll eindeutige Kennung, Absender, Zielraum, Inhalt, Erstellungszeitstempel und aktuellen Status enthalten.

**Quelle:** 
- `specs/chat_feature_spec.md` (Zeilen 74-81: „Unique identifier, Sender, Target room, Message content, Creation timestamp, Current status")
- `docs/testing/testbasis.md` (Abschnitt 4.4, Nachrichtenmodell)

**Gegeben** eine Nachricht wurde erstellt.

**Wenn** die Nachricht abgerufen wird.

**Dann** enthält die Nachricht alle erforderlichen Metadaten: eindeutige Kennung, Absender, Zielraum, Inhalt, Erstellungszeitstempel und aktuellen Status.

**Offene Bezüge:**
- Frage 11 (Testbasis Abschnitt 9.4): Soll Frontend Nachrichtenzeitstempel in Lokalzeit oder UTC anzeigen?

---

### AC-MSG-003: Nachricht hat initialen Status „sent"

**Anforderung:** Jede neue Nachricht erhält initial den Status „sent".

**Quelle:** 
- `specs/chat_feature_spec.md` (Zeilen 62-66: „Possible statuses: sent, delivered, read")
- `docs/testing/testbasis.md` (Abschnitt 4.4, Nachrichtenmodell)

**Gegeben** eine Nachricht wird erstellt und gesendet.

**Wenn** die Nachricht gespeichert wird.

**Dann** hat die Nachricht den Status `sent`.

**Offene Bezüge:**
- Keine

---

## 6. Messaging — Nachrichten anzeigen und filtern

### AC-MSG-004: Rezeption zeigt alle Nachrichten an

**Anforderung:** Rezeptionspersonal soll in der Lage sein, alle Nachrichten anzuzeigen.

**Quelle:** 
- `specs/chat_feature_spec.md` (Zeile 40: „View all messages")
- `docs/testing/testbasis.md` (Abschnitt 4.4)

**Gegeben** mehrere Nachrichten existieren.

**Wenn** das Rezeptionspersonal die Liste aller Nachrichten aufruft.

**Dann** werden alle Nachrichten mit Absender, Zielraum, Inhalt, Zeitstempel und Status angezeigt.

**Offene Bezüge:**
- Keine

---

### AC-MSG-005: Rezeption filtert Nachrichten nach Raum

**Anforderung:** Rezeptionspersonal soll in der Lage sein, Nachrichten nach Raum zu filtern.

**Quelle:** 
- `specs/chat_feature_spec.md` (Zeile 41: „Filter messages by room")
- `docs/testing/testbasis.md` (Abschnitt 4.4)

**Gegeben** mehrere Nachrichten für verschiedene Räume existieren.

**Wenn** das Rezeptionspersonal Nachrichten nach einem bestimmten Raum filtert.

**Dann** werden nur Nachrichten für diesen Raum angezeigt.

**Offene Bezüge:**
- Keine

---

### AC-MSG-006: Rezeption zeigt Details einer Nachricht an

**Anforderung:** Rezeptionspersonal soll in der Lage sein, Details einer einzelnen Nachricht anzuzeigen.

**Quelle:** 
- `specs/chat_feature_spec.md` (Zeile 42: „View message details")
- `docs/testing/testbasis.md` (Abschnitt 4.4)

**Gegeben** eine Nachricht mit bekannter Kennung existiert.

**Wenn** das Rezeptionspersonal die Details dieser Nachricht aufruft.

**Dann** werden alle Metadaten der Nachricht (Absender, Zielraum, Inhalt, Zeitstempel, Status) angezeigt.

**Offene Bezüge:**
- Keine

---

### AC-MSG-007: Gast zeigt Nachrichten des eigenen Raums an

**Anforderung:** Gäste sollen in der Lage sein, Nachrichten anzuzeigen, die ihrem Raum zugeordnet sind.

**Quelle:** 
- `specs/chat_feature_spec.md` (Zeilen 45-46: „Guests shall be able to: View messages assigned to their room")
- `specs/chat_feature_spec.md` (Zeilen 100-103, User Story 2: „As a guest I want to view messages assigned to my room")
- `docs/testing/testbasis.md` (Abschnitt 7.5, Gast-Nachrichtenansicht)

**Gegeben** ein Gast ruft die Nachrichtenansicht für einen bestimmten Raum auf.

**Wenn** Nachrichten für diesen Raum existieren.

**Dann** werden alle Nachrichten dieses Raums mit Absender, Inhalt, Zeitstempel und Status angezeigt.

**Offene Bezüge:**
- Frage 14 (Testbasis Abschnitt 9.4): Ist es fachlich korrekt, dass ein Gast alle Räume sehen kann?

---

## 7. Messaging — Status

### AC-MSG-008: Nachrichtenstatus ist bei Anzeige sichtbar

**Anforderung:** Der Status einer Nachricht soll beim Anzeigen sichtbar sein.

**Quelle:** 
- `specs/chat_feature_spec.md` (Zeile 68: „The status shall be visible when viewing messages")
- `docs/testing/testbasis.md` (Abschnitt 4.4)

**Gegeben** eine Nachricht mit einem bestimmten Status existiert.

**Wenn** die Nachricht angezeigt wird.

**Dann** ist der aktuelle Status der Nachricht sichtbar.

**Offene Bezüge:**
- Keine

---

### AC-MSG-009: Rezeption kann Status einer Nachricht ändern

**Anforderung:** Rezeptionspersonal soll in der Lage sein, den Status einer Nachricht zu ändern.

**Quelle:** 
- `docs/testing/testbasis.md` (Abschnitt 4.4, Funktionalität)
- Implizit aus User Story 3: `specs/chat_feature_spec.md` (Zeilen 109-113: „As a receptionist I want to see whether a message was read")

**Gegeben** eine Nachricht mit Status `sent` oder `delivered` existiert.

**Wenn** das Rezeptionspersonal den Status der Nachricht auf den nächsten erlaubten Status ändert.

**Dann** wird der neue Status für die Nachricht gespeichert und angezeigt.

**Offene Bezüge:**
- Siehe AC-MSG-010 für Einschränkungen der Status-Übergänge

---

### AC-MSG-010: Nachrichtenstatus schreitet nur vorwärts

**Anforderung:** Der Status einer Nachricht kann nur vorwärts schreiten: `sent → delivered → read`.

**Quelle:** 
- `specs/chat_feature_spec.md` (Zeilen 62-66: „Possible statuses: sent, delivered, read")
- `docs/testing/testbasis.md` (Abschnitt 7.3, Nachrichtenstatus-Progression)

**Gegeben** eine Nachricht mit einem bestimmten Status existiert.

**Wenn** versucht wird, den Status auf einen nicht erlaubten Zielstatus zu ändern (z. B. Rückwärts-Wechsel `delivered → sent` oder Überspringen `sent → read`).

**Dann** wird die Status-Änderung abgelehnt.

**Offene Bezüge:**
- Frage 13 (Testbasis Abschnitt 9.4): Gibt es einen Prozess, um versehentlich gesetzte Status zu korrigieren?

---

### AC-MSG-011: Status kann von „sent" zu „delivered" geändert werden

**Anforderung:** Der Status einer Nachricht kann von `sent` zu `delivered` geändert werden.

**Quelle:** 
- `docs/testing/testbasis.md` (Abschnitt 7.3, Nachrichtenstatus-Progression)
- `app/services/message_service.py` (Zeilen 7-11, ALLOWED_TRANSITIONS)

**Gegeben** eine Nachricht hat den Status `sent`.

**Wenn** der Status auf `delivered` geändert wird.

**Dann** wird der Status der Nachricht auf `delivered` gesetzt.

**Offene Bezüge:**
- Frage 15 (Testbasis Abschnitt 9.4): Bedeutet „delivered", dass die Nachricht API-seitig abgerufen wurde, oder dass sie im Browser angezeigt wurde?

---

### AC-MSG-012: Status kann von „delivered" zu „read" geändert werden

**Anforderung:** Der Status einer Nachricht kann von `delivered` zu `read` geändert werden.

**Quelle:** 
- `docs/testing/testbasis.md` (Abschnitt 7.3, Nachrichtenstatus-Progression)
- `app/services/message_service.py` (Zeilen 7-11, ALLOWED_TRANSITIONS)

**Gegeben** eine Nachricht hat den Status `delivered`.

**Wenn** der Status auf `read` geändert wird.

**Dann** wird der Status der Nachricht auf `read` gesetzt.

**Offene Bezüge:**
- Keine

---

## 8. Messaging — Persistenz

### AC-MSG-013: Nachrichten werden dauerhaft gespeichert

**Anforderung:** Nachrichten müssen dauerhaft gespeichert werden.

**Quelle:** 
- `specs/chat_feature_spec.md` (Zeile 52: „The system shall store messages permanently")
- `docs/testing/testbasis.md` (Abschnitt 7.4, Nachrichtenpersistenz)

**Gegeben** eine Nachricht wurde erstellt und gespeichert.

**Wenn** die Anwendung neu gestartet wird.

**Dann** ist die Nachricht nach dem Neustart weiterhin vorhanden und kann abgerufen werden.

**Offene Bezüge:**
- Frage 10 (Testbasis Abschnitt 9.4): Wie werden Nachrichten archiviert oder gelöscht? (Message-Deletion ist explizit out of scope)

---

### AC-MSG-014: Nachrichten bleiben nach Anwendungsneustart verfügbar

**Anforderung:** Gespeicherte Nachrichten sollen nach einem Anwendungsneustart verfügbar bleiben.

**Quelle:** 
- `specs/chat_feature_spec.md` (Zeile 54: „Stored messages shall remain available after application restart")
- `docs/testing/testbasis.md` (Abschnitt 7.4, Nachrichtenpersistenz)

**Gegeben** mehrere Nachrichten wurden vor einem Anwendungsneustart gespeichert.

**Wenn** die Anwendung neu gestartet und die Nachrichten abgerufen werden.

**Dann** sind alle zuvor gespeicherten Nachrichten mit allen Metadaten unverändert vorhanden.

**Offene Bezüge:**
- Keine

---

## 9. Nicht ableitbare Akzeptanzkriterien

Die folgenden Verhaltensweisen sind in der Implementierung vorhanden, konnten aber nicht aus belegten fachlichen Anforderungen abgeleitet werden. Sie erfordern Klärung, bevor Akzeptanzkriterien formuliert werden können.

### NA-001: Auto-Delivery beim Laden der Gastsicht

**Implementiertes Verhalten:**  
Beim Laden der Gastsicht werden alle Nachrichten mit Status `sent`, die nicht vom Gast stammen, automatisch auf `delivered` gesetzt.

**Quelle Implementierung:**  
`static/js/guest_messages.js` (Zeilen 43-53)

**Grund für Nicht-Ableitbarkeit:**  
Die fachliche Definition von „delivered" ist nicht in den Spezifikationen dokumentiert. Es ist unklar, ob „delivered" bedeutet:
- Die Nachricht wurde API-seitig abgerufen (aktuelles Verhalten), oder
- Die Nachricht wurde im Browser angezeigt / vom Gast tatsächlich gesehen

**Offener Bezug:**  
Frage 15 (Testbasis Abschnitt 9.4)

**Empfehlung:**  
Fachbereich muss Definition von „delivered" klären, bevor Akzeptanzkriterium formuliert werden kann.

---

### NA-002: Gast kann Nachrichten senden

**Implementiertes Verhalten:**  
Gäste können über die Gastsicht Nachrichten senden (nicht nur empfangen).

**Quelle Implementierung:**  
`static/guest_messages.html`, `static/js/guest_messages.js` (Zeilen 96-110)

**Grund für Nicht-Ableitbarkeit:**  
Die Chat Feature Specification (`specs/chat_feature_spec.md`) fordert explizit nur, dass Gäste Nachrichten **empfangen** können (Zeilen 45-46: „View messages assigned to their room"). Das Senden von Nachrichten durch Gäste ist nicht in der Spezifikation gefordert.

Laut `docs/decisions.md` (Decision 008) wurde der Scope bewusst erweitert: „Scope was widened beyond the original spec wording [...] to let guests also send messages". Dies ist eine Implementierungsentscheidung, keine belegte Anforderung aus der Spezifikation.

**Empfehlung:**  
Falls das Senden von Gast-Nachrichten als fachliche Anforderung bestätigt wird, kann ein Akzeptanzkriterium nachgetragen werden.

---

### NA-003: Sender-Feld ist Freitext

**Implementiertes Verhalten:**  
Das Sender-Feld ist ein Freitext-Feld ohne Validierung. Rezeption kann beliebige Absendernamen eingeben.

**Quelle Implementierung:**  
`app/models.py` (Zeile 48), `static/messages.html` (Zeile 31: Defaultwert „Reception")

**Grund für Nicht-Ableitbarkeit:**  
Die Spezifikation fordert, dass Nachrichten ein „Sender"-Metadatum enthalten (`specs/chat_feature_spec.md`, Zeile 77), definiert aber nicht:
- Ob „Sender" ein fester Wert ist (z. B. immer „Reception")
- Ob Mitarbeiter ihren Namen eingeben sollen
- Ob Validierung erforderlich ist

Laut `docs/decisions.md` (Decision 006) ist dies eine bewusste Design-Entscheidung („sender is a free-text string, no enum"), da keine Authentifizierung vorhanden ist. Dies ist jedoch eine Implementierungsentscheidung, keine belegte Anforderung.

**Offener Bezug:**  
Frage 12 (Testbasis Abschnitt 9.4)

**Empfehlung:**  
Fachbereich muss klären, ob Sender-Feld Freitext bleiben soll oder ob Validierung erforderlich ist.

---

### NA-004: Raum-Kategorien sind nicht validiert

**Implementiertes Verhalten:**  
Raum-Kategorien (Single, Double, Suite) sind Freitext ohne Validierung. Theoretisch können beliebige Kategorien gesetzt werden.

**Quelle Implementierung:**  
`app/models.py` (Zeile 19: `category = Column(String, nullable=False)`)

**Grund für Nicht-Ableitbarkeit:**  
Die Spezifikation nennt „Category" als Raum-Attribut (`specs/basis_spec.md`, Zeile 45), definiert aber nicht:
- Ob Kategorien feste Werte sind
- Welche Kategorien erlaubt sind
- Ob Validierung erforderlich ist

Die Seed-Daten (`app/seed.py`) enthalten „Single", „Double", „Suite", aber dies ist Implementierung, keine belegte Anforderung.

**Offener Bezug:**  
Frage 2 (Testbasis Abschnitt 9.1)

**Empfehlung:**  
Fachbereich muss klären, ob Kategorien fest vorgegeben sind oder Freitext bleiben.

---

### NA-005: Check-in/out-Datum ohne Zeitzone

**Implementiertes Verhalten:**  
Check-in- und Check-out-Daten werden als `date.today()` (Python-serverseitiges Datum ohne Zeitzone) gespeichert.

**Quelle Implementierung:**  
`app/services/checkinout_service.py` (Zeilen 22, 34)

**Grund für Nicht-Ableitbarkeit:**  
Die Spezifikation fordert, dass Check-in- und Check-out-Daten gespeichert werden (`specs/basis_spec.md`, Zeilen 87, 97), definiert aber nicht:
- In welcher Zeitzone die Daten gespeichert werden
- Wie Zeitzonen-Grenzfälle behandelt werden

**Offener Bezug:**  
Frage 6 (Testbasis Abschnitt 9.3)

**Empfehlung:**  
Fachbereich muss Zeitzone-Handling klären.

---

### NA-006: Mehrfach-Belegung eines Raums

**Implementiertes Verhalten:**  
Check-in prüft nur, ob Raum `available` ist, nicht, ob bereits ein anderer Gast im Raum eingecheckt ist.

**Quelle Implementierung:**  
`app/services/checkinout_service.py` (Zeilen 18-19)

**Grund für Nicht-Ableitbarkeit:**  
Die Spezifikation fordert, dass ein Raum einem Gast zugewiesen wird (`specs/basis_spec.md`, Zeile 85), definiert aber nicht explizit, ob ein Raum gleichzeitig mehreren Gästen zugewiesen sein kann.

`docs/architecture.md` (Zeile 87) erwähnt „at most one currently-checked-in guest", aber dies ist keine Spezifikationsanforderung.

**Offener Bezug:**  
Frage 1 (Testbasis Abschnitt 9.1)

**Empfehlung:**  
Fachbereich muss klären, ob Mehrfach-Belegung erlaubt ist.

---

### NA-007: Gastsicht zeigt alle Räume zur Auswahl

**Implementiertes Verhalten:**  
Wenn die Gastsicht ohne `room_id`-Parameter aufgerufen wird, wird eine Auswahlliste aller Räume angezeigt.

**Quelle Implementierung:**  
`static/guest_messages.html` (Zeilen 28-37), `static/js/guest_messages.js` (Zeilen 18-30)

**Grund für Nicht-Ableitbarkeit:**  
Die Spezifikation fordert, dass Gäste Nachrichten ihres Raums sehen können (`specs/chat_feature_spec.md`, Zeile 46), definiert aber nicht:
- Wie ein Gast seinen Raum auswählt
- Ob ein Gast alle Räume sehen darf

Laut `docs/decisions.md` (Decision 008) ist der Zugriff unauthenticated (`room_id` als URL-Parameter), aber dies ist Implementierungsentscheidung, keine belegte Anforderung.

**Offener Bezug:**  
Frage 14 (Testbasis Abschnitt 9.4)

**Empfehlung:**  
Fachbereich muss klären, ob Raumauswahl fachlich korrekt ist.

---

### NA-008: Nachrichten an leere Räume

**Implementiertes Verhalten:**  
Nachrichten können an Räume ohne aktive Gäste gesendet werden. Service prüft nur Raum-Existenz, nicht Gast-Zuweisung.

**Quelle Implementierung:**  
`app/services/message_service.py` (Zeilen 14-18)

**Grund für Nicht-Ableitbarkeit:**  
Die Spezifikation fordert, dass Nachrichten an Räume gesendet werden können (`specs/chat_feature_spec.md`, Zeile 30: „Select a target room"), definiert aber nicht, ob ein Gast im Raum sein muss.

**Offener Bezug:**  
Frage 9 (Testbasis Abschnitt 9.4)

**Empfehlung:**  
Fachbereich muss klären, ob Nachrichten an leere Räume erlaubt sind.

---

## 10. Qualitätsprüfung

Die folgenden Qualitätskriterien wurden bei der Erstellung geprüft:

### 10.1 Eindeutige und beobachtbare Ergebnisse
✓ Alle Akzeptanzkriterien beschreiben ein eindeutig prüfbares Verhalten  
✓ Erwartete Ergebnisse sind beobachtbar (z. B. „wird angezeigt", „wird gespeichert", „wird abgelehnt")

### 10.2 Korrekte Quellenangaben
✓ Jedes Akzeptanzkriterium enthält mindestens eine Quellenangabe  
✓ Quellenangaben verweisen auf Spezifikationen oder Testbasis  
✓ Zeilennummern sind angegeben, wo verfügbar

### 10.3 Keine unbelegten Annahmen
✓ Kriterien wurden nur aus belegten Anforderungen abgeleitet  
✓ Implementierungsverhalten ohne belegte Anforderung wurde in Abschnitt 9 aufgeführt  
✓ Keine technischen Details (HTTP-Statuscodes, DB-Schema) ohne belegte Anforderung eingefügt

### 10.4 Keine vermischten Verhaltensweisen
✓ Jedes Akzeptanzkriterium prüft ein spezifisches Verhalten  
✓ Komplexe Szenarien wurden in mehrere Kriterien aufgeteilt (z. B. AC-MSG-011, AC-MSG-012)

### 10.5 Fachliche statt technische Formulierung
✓ Kriterien beschreiben fachliches Verhalten („Rezeptionspersonal weist zu"), nicht technische Implementierung („POST /api/checkin")  
✓ HTTP-Statuscodes, API-Endpunkte, DB-Felder wurden vermieden  
✓ Ausnahme: Wo Spezifikation Status-Enums definiert (`sent`, `delivered`, `read`, `available`, `occupied`, `cleaning`), wurden diese übernommen

---

## 11. Zusammenfassung

**Abgeleitete Akzeptanzkriterien:** 27  
- Raum-Management: 5 (AC-ROOM-001 bis AC-ROOM-005)
- Gäste-Management: 6 (AC-GUEST-001 bis AC-GUEST-006)
- Check-in / Check-out: 6 (AC-CHECKIN-001 bis AC-CHECKIN-006)
- Messaging: 14 (AC-MSG-001 bis AC-MSG-014)

**Nicht ableitbare Kriterien:** 8 (NA-001 bis NA-008)  
Diese erfordern fachliche Klärung, bevor Akzeptanzkriterien formuliert werden können.

**Offene Fragen aus Testbasis referenziert:** 15

---

**Ende der Akzeptanzkriterien**
