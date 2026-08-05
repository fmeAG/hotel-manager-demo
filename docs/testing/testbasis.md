# Testbasis: Hotel- und Chatfunktion

**Erstellt am:** 2026-08-04
**Grundlage:** `docs/testing/analyse_20260804.md` (geprüft, nicht ungeprüft übernommen — siehe Hinweis unten), ergänzend die darin genannten Originalquellen
**Projektstand:** `[Unreleased]` laut `docs/changelog.md`; HEAD-Commit zum Erstellungszeitpunkt `62459b8`

## Hinweis zur Vorgehensweise

Dieses Dokument wurde nicht durch bloßes Übernehmen von `analyse_20260804.md`
erstellt. Jede darin als BELEGT gekennzeichnete Aussage wurde anhand der
genannten Originalquelle (`specs/`, `docs/`, `app/`, `static/`) erneut
geprüft. Dabei wurden folgende Korrekturen gegenüber der Analyse vorgenommen:

- Der in der Analyse unter „Widersprüche" (6.2) referenzierte mögliche
  Widerspruch zur Scope-Boundaries-Formulierung in `docs/overview.md` wurde
  bei erneuter Prüfung der Datei **nicht bestätigt** (siehe Abschnitt 10) und
  daher hier nicht als Widerspruch geführt.
- Mehrere in der Analyse unter „Vorhandene Funktionen" als BELEGT geführte
  Verhaltensweisen sind **technische Implementierungsentscheidungen**
  (dokumentiert in `docs/decisions.md`), nicht unmittelbar aus den
  Fachspezifikationen (`specs/basis_spec.md`, `specs/chat_feature_spec.md`)
  ableitbare Anforderungen. Sie werden hier entsprechend als „bekannte
  Rahmenbedingungen" (Abschnitt 6) statt als „belegte fachliche Anforderung"
  (Abschnitt 7) geführt, um Implementierungsverhalten nicht unbemerkt zur
  Anforderung zu erklären.
- Der in der Analyse unter „Widerspruch 6.4" (API-Doku vs. Implementierung,
  422-Codes) geführte Punkt ist bei genauerer Betrachtung keine
  Gegensätzlichkeit zweier Quellen, sondern eine Dokumentationslücke; er wird
  hier unter „offene fachliche Fragen" statt unter „Widersprüche" geführt.
- Ein in der Analyse nicht benannter, aber bei Quellenprüfung aufgefallener
  **stärkerer Widerspruch** wurde ergänzt: Beide Spezifikationen fordern
  wörtlich automatisierte Tests, das Repository enthält aktuell jedoch keinen
  einzigen Test (siehe Abschnitt 10).

---

## 1. Ziel der Testaktivitäten

Ziel ist der Aufbau einer geprüften, nachvollziehbaren Testbasis für die
Hotel-Kernfunktionen (Raum- und Gästemanagement, Check-in/Check-out) und die
Chatfunktion (Messaging zwischen Rezeption und Gästen) der
Hotel-Management-Anwendung. Diese Testbasis unterscheidet belegte fachliche
Anforderungen von Annahmen, offenen Fragen und Widersprüchen und bildet die
Grundlage für die nachfolgende Ableitung von Akzeptanzkriterien
(`akzeptanzkriterien.md`), einer Risikoanalyse (`risikoanalyse.md`) und
konkreter Testfälle (`testfaelle.md`). Offene Fragen und Widersprüche werden
in diesem Schritt bewusst **nicht** aufgelöst.

---

## 2. Testgegenstand

Die lauffähige Hotel-Management-Anwendung (FastAPI-Backend + statisches
HTML/JS-Frontend, SQLite-Persistenz), bestehend aus:

- **Backend:** `app/` — REST-API unter `/api` (Rooms, Guests,
  Check-in/Check-out, Messages), Business-Logik in `app/services/`,
  Persistenz in `app/repositories/` und `app/models.py`.
- **Frontend:** `static/` — Rezeptionsseiten (`rooms.html`, `guests.html`,
  `checkin.html`, `messages.html`) und die unauthentifizierte Gastsicht
  (`guest_messages.html`).
- **Persistenz:** SQLite (`hotel.db` bzw. `data/hotel.db` im
  Docker-Compose-Betrieb).

**Quelle:** `docs/architecture.md` (Zeilen 1-53), `docker-compose.yml`

Im Fokus dieser Testbasis stehen ausdrücklich die Hotel- und die
Chatfunktion (siehe Abschnitt 4).

---

## 3. Betrachtete fachliche und technische Quellen

### Fachliche Spezifikationen

- `specs/basis_spec.md` — Grundspezifikation Raum-/Gästemanagement,
  Check-in/Check-out, Non-Functional Requirements, Known Limitations.
- `specs/chat_feature_spec.md` — Fachspezifikation der Chatfunktion,
  inkl. User Stories, Qualitätsanforderungen, explizit offener Fragen und
  Akzeptanzkriterien auf Spezifikationsebene.
- `specs/architecture_options.md` — Architekturvergleich für die
  Chat-Zustellung (Option A gewählt).

### Projektdokumentation

- `docs/overview.md`, `docs/architecture.md`, `docs/api.md`,
  `docs/decisions.md` (Decision 001–009), `docs/changelog.md`,
  `docs/chat_gap_analysis.md`, `docs/documentation_structure.md`.

### Quellcode (vollständig geprüft)

- Backend: `app/models.py`, `app/database.py`, `app/main.py`, `app/seed.py`,
  `app/services/{room,guest,checkinout,message}_service.py`,
  `app/repositories/{room,guest,message}_repository.py`,
  `app/api/{rooms,guests,checkinout,messages}.py`.
- Frontend: `static/*.html`, `static/js/*.js`, `static/css/style.css`.
- Konfiguration: `Dockerfile`, `docker-compose.yml`.

### Vorherige Analyse

- `docs/testing/analyse_20260804.md` — als Ausgangspunkt herangezogen, jede
  darin enthaltene Aussage wurde gegen die oben genannten Originalquellen
  geprüft (siehe Hinweis zur Vorgehensweise).

### Nicht als fachliche Quelle herangezogen

- `schulungsmaterial/Aufgaben-KI-Testing.md`/`.html` — Kursmaterial zum
  Schulungsablauf, keine Quelle über die Anwendung selbst.

---

## 4. Funktionen innerhalb des Testumfangs

**Quelle:** Auftrag „Betrachte insbesondere die Hotel- und Chatfunktion"
sowie `docs/overview.md` (Zeilen 13-17)

- Raum-Management: Räume auflisten, Rauminformationen abrufen, Raumstatus
  ändern.
- Gäste-Management: Gäste anlegen, auflisten, abrufen, bearbeiten, löschen.
- Check-in: Raum einem Gast zuweisen.
- Check-out: Raumzuweisung entfernen.
- Messaging Rezeption: Nachricht an einen Raum senden, Nachrichten auflisten
  und nach Raum filtern, Nachrichtendetails ansehen, Nachrichtenstatus
  ändern.
- Messaging Gast: Nachrichten des eigenen Raums ansehen, Nachrichten senden,
  Status „read" setzen (soweit über die unauthentifizierte Gastsicht
  erreichbar).

---

## 5. Funktionen außerhalb des Testumfangs

**Quelle:** `specs/basis_spec.md` (Zeilen 34, 163-173), `specs/chat_feature_spec.md` (Zeilen 170-180)

- Authentifizierung / Autorisierung — explizit nicht Teil der Anwendung
  (`specs/basis_spec.md`, Zeile 34, 170).
- Push-Benachrichtigungen — explizit ausgeschlossen
  (`specs/basis_spec.md`, Zeile 167; `specs/chat_feature_spec.md`, Zeile 174).
- Echtzeitkommunikation — explizit ausgeschlossen (beide Spezifikationen).
- Mobile Anwendungen — explizit ausgeschlossen
  (`specs/chat_feature_spec.md`, Zeile 177).
- Nachrichtenanhänge — explizit ausgeschlossen
  (`specs/chat_feature_spec.md`, Zeile 179).
- Löschen von Nachrichten — explizit ausgeschlossen
  (`specs/chat_feature_spec.md`, Zeile 180); es existiert kein
  `DELETE`-Endpunkt für Nachrichten (`app/api/messages.py`, geprüft:
  keine solche Route vorhanden).
- Raum-Neuanlage über die API — es existiert kein Endpunkt zum Anlegen neuer
  Räume; Räume entstehen ausschließlich über die Seed-Daten
  (`app/seed.py`; `app/api/rooms.py`, geprüft: nur `GET`/`PATCH`-Routen
  vorhanden). Dies ist keine explizite Spec-Ausschlussliste, sondern ein
  beobachteter Funktionsumfang — daher hier als Umfangsgrenze, nicht als
  belegte fachliche Anforderung geführt.
- Automatisierte Testsuite (Robot Framework) — laut Schulungsablauf
  Gegenstand einer Folgeaufgabe, hier nicht Testgegenstand.

---

## 6. Bekannte Rahmenbedingungen und Einschränkungen

Diese Punkte beschreiben den aktuell implementierten bzw. dokumentierten
Zustand des Systems. Sie sind **technische/organisatorische
Rahmenbedingungen**, keine aus der Fachspezifikation abgeleiteten
Anforderungen, sofern nicht anders vermerkt.

- **Keine Authentifizierung im gesamten System, auch nicht in der
  Gastsicht.** Zugriff auf `/guest_messages.html?room_id=` erfolgt allein
  über die Raum-ID als URL-Parameter.
  **Quelle:** `docs/decisions.md` (Decision 008), `docs/architecture.md`
  (Zeilen 107-110) — konsequente Umsetzung der spezifizierten
  Auth-Ausschlussgrenze (Abschnitt 5).
- **Keine automatisierten Tests im Repository vorhanden** (0 Tests). Der
  letzte verbliebene Test wurde mit Commit `9acf5ef` entfernt.
  **Quelle:** Prüfung des Arbeitsverzeichnisses (kein `tests/`-Ordner mehr
  vorhanden), `git log --oneline`. Siehe auch Widerspruch in Abschnitt 10.
- **Raumstatus-Übergangsregel:** Ein Raum mit Status `occupied` kann nur
  nach `cleaning` wechseln; jeder andere Zielstatus liefert `409`.
  Check-out setzt den Raum automatisch auf `cleaning`, nicht auf
  `available`. **Quelle:** `docs/decisions.md` (Decision 009),
  `app/services/room_service.py` (Zeilen 18-25), `app/services/checkinout_service.py`
  (Zeile 33), `docs/api.md` (Zeilen 44-46, 134-135). Diese konkrete
  technische Umsetzung wird von `specs/basis_spec.md` (Zeile 98: „Mark the
  room as available only after cleaning is complete") inhaltlich getragen,
  die genaue Statuswert-Bezeichnung (`cleaning`) und der 409-Mechanismus
  sind jedoch Implementierungsentscheidungen (Decision 009), keine
  wörtliche Spezifikationsvorgabe.
- **Check-in-/Check-out-Vorbedingungen** (Gast darf noch keinen Raum haben;
  Raum muss `available` sein; Gast muss aktuell einen Raum haben für
  Check-out) werden im Service-Layer als `409 Conflict` durchgesetzt.
  **Quelle:** `app/services/checkinout_service.py` (Zeilen 8-34),
  `docs/api.md` (Zeilen 126-127, 137). Diese konkreten Vorbedingungen sind
  in den Spezifikationen nicht wörtlich benannt; sie sind dokumentiertes,
  aber nicht spezifiziertes Verhalten.
- **Löschen eines Gasts** ist nur möglich, wenn kein Raum zugewiesen ist
  (`room_id == null`), sonst `409`. **Quelle:** `app/services/guest_service.py`
  (Zeilen 26-33), `docs/api.md` (Zeile 106-107). Ebenfalls nicht wörtlich
  in `specs/basis_spec.md` gefordert.
- **Nachrichtenstatus-Übergänge** sind ausschließlich vorwärts und in
  Einzelschritten erlaubt (`sent → delivered → read`); jeder andere
  Übergang liefert `409`. **Quelle:** `app/services/message_service.py`
  (Zeilen 7-11, 32-39), `docs/decisions.md` (Decision 006), `docs/api.md`
  (Zeilen 202-205). `specs/chat_feature_spec.md` benennt „Read-status
  handling" ausdrücklich als offene Frage (Zeile 151) — die konkrete
  Übergangsregel ist eine Implementierungsentscheidung, keine
  Spezifikationsvorgabe.
- **Guest-Nachrichten senden** (nicht nur lesen) ist möglich und
  implementiert, geht jedoch über den Wortlaut von
  `specs/chat_feature_spec.md` Story 2 (nur „View messages assigned to
  their room") hinaus. **Quelle:** `docs/decisions.md` (Decision 008, „Scope
  was widened beyond the original spec wording ... This is a deliberate
  scope decision, not an oversight"). Dies ist damit **keine** aus der
  Chat-Spezifikation ableitbare Anforderung, sondern eine dokumentierte,
  bewusste Erweiterung.
- **Automatische Status-Transition „delivered"** beim Laden der Gastsicht
  für nicht vom Gast stammende Nachrichten; „read" bleibt eine explizite
  Nutzeraktion. **Quelle:** `docs/decisions.md` (Decision 008),
  `static/js/guest_messages.js` (Zeilen 43-53, 64-71). Ebenfalls eine
  Implementierungsentscheidung zu einer laut Spezifikation offenen Frage.
- **Sender-Feld ist ungeprüfter Freitext** ohne Bezug zu einer
  authentifizierten Identität, sowohl in der Rezeptions- als auch in der
  Gastsicht. **Quelle:** `docs/decisions.md` (Decision 006, „Consequences"),
  `app/api/messages.py` (Zeilen 25-28).
- **Keine serverseitige Eingabevalidierung** (Leerstring, Länge, Zeichen)
  für Gastnamen und Nachrichteninhalt/Sender; nur clientseitiges
  HTML-`required`-Attribut. **Quelle:** `app/api/guests.py` (Zeilen 24-26),
  `app/api/messages.py` (Zeilen 25-28), `static/guests.html` (Zeilen 30-31),
  `static/messages.html` (Zeile 32).
- **Zeichensatz:** Seit Version 1.3.1 werden Umlaute/ß bei Gastnamen korrekt
  gespeichert; zuvor erfolgte eine ASCII-Sanitierung ohne Fehlermeldung.
  Keine Migration für Altdaten. **Quelle:** `docs/decisions.md`
  (Decision 007), `docs/changelog.md` (Version 1.3.1).
- **Architektur:** Drei-Schichten-Modell (API → Services → Repositories),
  eine gemeinsame SQLite-Datenbank für alle drei Entitäten, synchrone
  REST-Kommunikation ohne Message Broker oder Realtime-Push.
  **Quelle:** `docs/architecture.md` (gesamt), `specs/architecture_options.md`
  (Option A gewählt).

---

## 7. Belegte fachliche Anforderungen

Ausschließlich Anforderungen mit unmittelbarer Grundlage in den
Fachspezifikationen (`specs/basis_spec.md`, `specs/chat_feature_spec.md`)
bzw. deren Wiedergabe in `docs/overview.md`.

### Raum-Management

**Quelle:** `specs/basis_spec.md` (Zeilen 42-58)

- Ein Raum enthält: Raumnummer, Kategorie, Belegungsstatus.
- Mögliche Raumstatus: Available, Occupied, Cleaning.
- Rezeption kann: Räume auflisten, Raumdetails ansehen, Raumstatus ändern.

### Gäste-Management

**Quelle:** `specs/basis_spec.md` (Zeilen 64-77)

- Ein Gast enthält: Vorname, Nachname, zugewiesener Raum, Check-in-Datum,
  Check-out-Datum.
- Rezeption kann: Gäste anlegen, ansehen, bearbeiten, löschen.

### Check-in

**Quelle:** `specs/basis_spec.md` (Zeilen 83-87)

- Rezeption kann einem Gast einen Raum zuweisen, den Raum als belegt
  markieren und das Check-in-Datum speichern.

### Check-out

**Quelle:** `specs/basis_spec.md` (Zeilen 93-98)

- Rezeption kann die Raumzuweisung entfernen, den Raum als „cleaning"
  markieren, das Check-out-Datum speichern.
- Der Raum darf erst nach abgeschlossener Reinigung wieder als verfügbar
  markiert werden.

### Messaging — Senden (Rezeption)

**Quelle:** `specs/chat_feature_spec.md` (Zeilen 25-32, User Story 1)

- Rezeption kann eine Nachricht erstellen, einen Zielraum auswählen, einen
  Text eingeben und die Nachricht senden.

### Messaging — Anzeigen (Rezeption)

**Quelle:** `specs/chat_feature_spec.md` (Zeilen 36-42)

- Rezeption kann alle Nachrichten ansehen, nach Raum filtern,
  Nachrichtendetails ansehen.

### Messaging — Anzeigen (Gast)

**Quelle:** `specs/chat_feature_spec.md` (Zeilen 44-46, User Story 2)

- Gäste können die ihrem Raum zugeordneten Nachrichten ansehen.

### Nachrichtenhistorie

**Quelle:** `specs/chat_feature_spec.md` (Zeilen 50-54)

- Nachrichten werden dauerhaft gespeichert.
- Gespeicherte Nachrichten bleiben nach einem Neustart der Anwendung
  verfügbar.

### Nachrichtenstatus

**Quelle:** `specs/chat_feature_spec.md` (Zeilen 58-68, User Story 3)

- Jede Nachricht hat einen Status aus: sent, delivered, read.
- Der Status ist beim Anzeigen einer Nachricht sichtbar.
- Rezeption kann erkennen, ob eine Nachricht gelesen wurde.

### Nachrichten-Metadaten

**Quelle:** `specs/chat_feature_spec.md` (Zeilen 72-81)

- Jede Nachricht enthält: eindeutige ID, Sender, Zielraum,
  Nachrichteninhalt, Erstellungszeitstempel, aktuellen Status.

### Nicht-funktionale Anforderungen

**Quelle:** `specs/basis_spec.md` (Zeilen 104-128), `specs/chat_feature_spec.md` (Zeilen 117-124)

- Die Anwendung nutzt Python, FastAPI, SQLite, Docker Compose.
- Die Anwendung stellt eine REST-API und eine Browser-basierte
  Benutzeroberfläche bereit.
- Die Architektur trennt API, Business-Logik und Persistenz.
- **Automatisierte Tests sind laut beiden Spezifikationen ausdrücklich
  gefordert** (Code-Quality- bzw. Quality-Requirements-Abschnitt). Der
  aktuelle Repository-Zustand erfüllt diese Anforderung nicht (siehe
  Widerspruch, Abschnitt 10).

---

## 8. Dokumentierte Annahmen

Aussagen, die aus Code-Verhalten plausibel abgeleitet, aber durch keine der
geprüften Quellen ausdrücklich bestätigt sind.

- **ANNAHME:** Bei nahezu gleichzeitigen Check-in-Anfragen auf denselben
  Raum könnte ein Race Condition auftreten, da Statusprüfung und
  -aktualisierung im Code als zwei getrennte, nicht erkennbar
  transaktional abgesicherte Schritte erfolgen.
  **Quelle der Beobachtung:** `app/services/checkinout_service.py`
  (Zeilen 8-22), `app/repositories/room_repository.py` (Zeilen 14-18).
  Keine Dokumentation äußert sich zu Nebenläufigkeitsverhalten.
- **ANNAHME:** Ein doppelter Aufruf des Auto-Delivery-Mechanismus (z. B.
  durch zwei parallel geöffnete Gastsicht-Tabs auf denselben Raum) führt
  vermutlich zu einem serverseitig abgefangenen `409 Conflict` beim
  zweiten Aufruf, nicht zu Dateninkonsistenz. Dies ist aus der
  Übergangslogik in `app/services/message_service.py` (Zeilen 7-11)
  plausibel abgeleitet, aber durch keinen Test oder keine Dokumentation
  bestätigt.
- **ANNAHME:** Für aktuelle Seed- und Testdaten sind historisch durch die
  frühere ASCII-Sanitierung (vor Version 1.3.1) korrumpierte Gastnamen
  nicht relevant, da `app/seed.py` keine Gäste anlegt und somit keine
  betroffenen Altdaten im Auslieferungszustand existieren.

---

## 9. Offene fachliche Fragen

- **OFFEN:** Ist die reine Raumstatusprüfung (`room.status == available`)
  eine fachlich ausreichende Absicherung gegen die gleichzeitige
  Zuordnung mehrerer aktiver Gäste zu einem Raum, oder wird eine direkte
  Prüfung auf Raumebene benötigt? **Quelle:** `app/models.py` (Zeile 31 —
  kein UNIQUE-Constraint auf `Guest.room_id`), `docs/architecture.md`
  (Zeile 87).
- **OFFEN:** Existiert eine feste Liste zulässiger Raumkategorien, oder
  sind beliebige Zeichenketten zulässig? **Quelle:** `app/models.py`
  (Zeile 19 — `category` ohne Enum/Validierung), `docs/overview.md`
  nennt nur Beispielkategorien.
  Zusammenhängend: Ist das Fehlen eines API-Endpunkts zum Anlegen neuer
  Räume beabsichtigt?
- **OFFEN:** Wer ist fachlich für den manuellen Übergang `cleaning →
  available` zuständig (Housekeeping, Rezeption, beliebige Person mit
  UI-Zugriff)? **Quelle:** Keine Dokumentation benennt eine
  Verantwortlichkeit; `app/services/room_service.py` schränkt diesen
  Übergang technisch nicht ein.
- **OFFEN:** Gibt es Anforderungen an Länge oder Format von Gastnamen
  (z. B. Pflichtfeld ohne Leerstring, maximale Länge)?
  **Quelle:** Keine Validierung in `app/services/guest_service.py`
  dokumentiert oder implementiert.
- **OFFEN:** Ist das Löschen eines ausgecheckten Gasts inklusive seiner
  historischen Check-in-/Check-out-Daten fachlich gewollt, oder wird eine
  Aufenthaltshistorie benötigt? **Quelle:** Keine Audit-/Historientabelle
  im Datenmodell (`app/models.py`); keine Aussage in `specs/basis_spec.md`.
- **OFFEN:** In welcher Zeitzone werden Check-in-/Check-out-Datum sowie
  der Nachrichtenzeitstempel geführt bzw. angezeigt? **Quelle:**
  `app/services/checkinout_service.py` (`date.today()`, Server-Lokalzeit),
  `app/models.py` (Zeile 51, `datetime.utcnow`), Frontend-Anzeige über
  `toLocaleString()` (`static/js/messages.js` Zeile 31,
  `static/js/guest_messages.js` Zeile 81) — keine Spezifikation äußert
  sich dazu.
- **OFFEN:** Ist ein direkter Zimmerwechsel ohne vorherigen Check-out
  fachlich vorgesehen? **Quelle:** `app/services/checkinout_service.py`
  (Zeilen 12-13) verweigert Check-in bei bereits zugewiesenem Raum; keine
  Spezifikationsaussage dazu.
- **OFFEN:** Darf eine Nachricht an einen Raum ohne aktuell zugeordneten
  Gast gesendet werden? **Quelle:** `app/services/message_service.py`
  (Zeilen 14-18) prüft nur die Existenz des Raums, nicht die
  Gastzuordnung; keine Spezifikationsaussage.
- **OFFEN:** Wie sollen Nachrichten langfristig archiviert oder im Hinblick
  auf Datenschutzanforderungen (personenbezogene Inhalte) behandelt
  werden? **Quelle:** `specs/chat_feature_spec.md` schließt nur „Message
  deletion" als Funktion aus (Zeile 180), äußert sich aber nicht zu
  Aufbewahrung/Archivierung.
- **OFFEN:** Ist der voreingestellte Wert „Reception" im Sender-Feld der
  Rezeptionssicht verbindlich vorgeschrieben, oder darf frei ein anderer
  Wert (z. B. Mitarbeitername) eingetragen werden? **Quelle:**
  `static/messages.html` (Zeile 31) — reiner UI-Default ohne
  Spezifikationsvorgabe.
- **OFFEN:** Existiert ein fachlicher Korrekturweg für einen versehentlich
  gesetzten Nachrichtenstatus, da nur Vorwärtsübergänge erlaubt sind?
  **Quelle:** `app/services/message_service.py` (Zeilen 7-11) — keine
  Spezifikationsaussage.
- **OFFEN:** Bedeutet der Status „delivered" fachlich „vom Client
  abgerufen" oder „vom Gast tatsächlich wahrgenommen"? **Quelle:**
  `specs/chat_feature_spec.md` benennt „Read-status handling" ausdrücklich
  als offene Frage (Zeile 151); die aktuelle Umsetzung
  (`static/js/guest_messages.js`, Zeilen 43-53) setzt „delivered"
  automatisch beim Laden der Seite.
- **OFFEN:** Sind die von FastAPI/Pydantic automatisch erzeugten
  `422`-Antworten bei fehlenden oder falsch typisierten Pflichtfeldern
  fachlich als erwartetes Verhalten zu werten? **Quelle:** `docs/api.md`
  dokumentiert durchgehend nur 200/201/404/409 und äußert sich nicht zu
  422-Fällen; ursprünglich in `analyse_20260804.md` als „Widerspruch"
  geführt, hier als Dokumentationslücke/offene Frage eingeordnet, da keine
  zwei Quellen einander tatsächlich widersprechen.

---

## 10. Gefundene Widersprüche

- **WIDERSPRUCH:** Beide Fachspezifikationen fordern wörtlich
  automatisierte Tests als Qualitätsanforderung
  (`specs/basis_spec.md`, Zeilen 120-127, „Include automated tests";
  `specs/chat_feature_spec.md`, Zeilen 119-124, „Include automated tests").
  Das aktuelle Repository enthält jedoch **keinen einzigen** automatisierten
  Test (kein `tests/`-Verzeichnis mehr vorhanden; letzter Test entfernt mit
  Commit `9acf5ef`, „chore: remove unused checkout tests"). Dieser
  Widerspruch besteht zwischen Fachspezifikation und tatsächlichem
  Projektzustand.
- **WIDERSPRUCH:** `docs/changelog.md` behauptet für Version 1.0.0 „22
  Unit-Tests" und „Integration tests for all API endpoints" (Zeilen 95-96)
  sowie für Version 1.3.0 zusätzlich Unit- und Integrationstests für die
  Messaging-Funktion (Zeile 48). Das aktuelle Repository enthält davon
  nichts mehr. Der Abschnitt `[Unreleased]` (Zeile 18) dokumentiert zwar
  die Entfernung einer „Pytest suite", ohne jedoch zu benennen, dass davon
  auch die für 1.3.0 behaupteten Message-Tests betroffen waren bzw. ob
  diese je im versionierten Stand existierten.
- **Historischer Widerspruch, bereits im Quelldokument aufgelöst:**
  `docs/decisions.md`, Decision 003 (Zeilen 33-48), beschreibt „The
  checkout process sets the room to `available` automatically"; Decision
  009 (Zeilen 140-151) beschreibt stattdessen den Übergang zu `cleaning`
  und ist im Dokument selbst ausdrücklich als „Supersedes [Decision 003]"
  markiert. Die Implementierung (`app/services/checkinout_service.py`,
  Zeile 33) folgt eindeutig Decision 009. Dieser Punkt wird hier nur der
  Vollständigkeit halber aufgeführt; er erfordert keine weitere fachliche
  Klärung, da die Quelle die Auflösung bereits selbst dokumentiert.
- **Geprüft, aber nicht bestätigt:** Ein in `analyse_20260804.md` (Abschnitt
  6.2) vermuteter Widerspruch zwischen der Beschreibung der
  Messaging-Funktion und den „Scope Boundaries" in `docs/overview.md`
  wurde bei erneuter Prüfung der Datei (Zeilen 17, 32-38) **nicht
  bestätigt**: Der Scope-Boundaries-Abschnitt listet ausschließlich „Push
  notifications" und „Real-time communication" als nicht im Scope,
  benennt „Messaging" dort nicht (mehr). Die Datei ist in der aktuell
  vorliegenden Fassung in sich konsistent. Dieser Punkt wird hier bewusst
  **nicht** als Widerspruch geführt.

---

## 11. Erste bekannte Produktrisiken

Vorläufige, noch nicht priorisierte Auflistung als Ausgangspunkt für
`risikoanalyse.md`. Eine detaillierte Bewertung (Eintrittswahrscheinlichkeit,
Priorität, Testideen) erfolgt in diesem Dokument nicht.

- **Cross-Site-Scripting (XSS) über Nachrichteninhalt/Sender.** Beide
  Frontend-Skripte (`static/js/messages.js`, Zeilen 27-35;
  `static/js/guest_messages.js`, Zeilen 78-84) bauen Tabellenzeilen über
  `innerHTML` mit ungeschützt interpolierten Werten aus `sender` und
  `content` auf. Da beide Felder über die unauthentifizierte Gastsicht frei
  befüllbar sind, kann eingeschleustes HTML/JavaScript in beiden Ansichten
  aktiv ausgeführt werden. **Status:** BELEGT durch Code-Prüfung.
- **Fehlende Authentifizierung/Autorisierung.** Bewusste, dokumentierte
  Scope-Grenze (`specs/basis_spec.md`, Zeile 34; `docs/decisions.md`
  Decision 008), aber mit fachlicher Konsequenz, dass jede Person mit
  Kenntnis einer Raum-ID fremde Nachrichten lesen/senden kann.
- **Sender-Impersonation.** Kein serverseitiger Abgleich des `sender`-Werts
  gegen eine erlaubte Werteliste oder einen Identitätsnachweis. **Quelle:**
  `docs/decisions.md` (Decision 006, „Consequences").
- **Fehlende Testabdeckung.** Kein automatisierter Test vorhanden (siehe
  Abschnitt 10); jede Regression bliebe ohne manuelle Prüfung unbemerkt.
- **Race Conditions bei parallelem Check-in.** ANNAHME, siehe Abschnitt 8.
- **Fehlendes Fehler-Feedback im Frontend.** Weder `static/js/messages.js`
  (Zeilen 51-63) noch `static/js/guest_messages.js` (Zeilen 96-110) prüfen
  den Response-Status nach `POST`/`PATCH`-Aufrufen; Eingabefelder werden
  auch bei einem Serverfehler geleert.
- **Historisch korrumpierte Gastnamen** (vor Version 1.3.1). Für aktuelle
  Seed-/Testdaten voraussichtlich nicht relevant (siehe ANNAHME, Abschnitt
  8), bei produktiven Altdaten jedoch potenziell wirksam.

---

**Ende der Testbasis**
