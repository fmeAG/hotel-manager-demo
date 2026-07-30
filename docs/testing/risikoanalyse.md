# Risikoanalyse: Hotel-Management-Anwendung mit Messaging

**Erstellungsdatum:** 2026-07-30  
**Projektstand:** Version 1.4.0  
**Basis:** `docs/testing/testbasis.md`, `docs/testing/akzeptanzkriterien.md`

---

## 1. Übersicht

Dieses Dokument beschreibt die identifizierten Produktrisiken für die Hotel-Management-Anwendung mit Messaging-Funktion. Die Risikoanalyse basiert auf den bestätigten Akzeptanzkriterien und den in der Testbasis dokumentierten Produktrisiken.

**Risiko-IDs:**
- **R-ROOM-NNN:** Raum-Management
- **R-GUEST-NNN:** Gäste-Management
- **R-CHECKIN-NNN:** Check-in / Check-out
- **R-MSG-NNN:** Messaging
- **R-SEC-NNN:** Sicherheit (übergreifend)
- **R-PERF-NNN:** Performance (übergreifend)

**Bewertungsskala:**

| Auswirkung | Eintrittswahrscheinlichkeit | Priorität |
|---|---|---|
| **Hoch:** Datenverlust, kritische Geschäftsprozesse blockiert, falscher Raum-Status | **Hoch:** Regelmäßig im Normalbetrieb | **Kritisch:** Auswirkung HOCH + Wahrscheinlichkeit HOCH |
| **Mittel:** Inkorrekte Anzeige, Verwirrung, suboptimale UX | **Mittel:** Gelegentlich, z. B. bei Grenzfällen | **Hoch:** Auswirkung HOCH + Wahrscheinlichkeit MITTEL, oder Auswirkung MITTEL + Wahrscheinlichkeit HOCH |
| **Niedrig:** Kosmetischer Fehler, minimale Beeinträchtigung | **Niedrig:** Selten, nur unter speziellen Bedingungen | **Mittel:** Auswirkung MITTEL + Wahrscheinlichkeit MITTEL, oder Auswirkung HOCH + Wahrscheinlichkeit NIEDRIG |
|  |  | **Niedrig:** Auswirkung NIEDRIG oder Wahrscheinlichkeit NIEDRIG |

---

## 2. Raum-Management

### R-ROOM-001: Inkorrekte Status-Anzeige bei gleichzeitigen Status-Änderungen

**Betroffene Akzeptanzkriterien:** AC-ROOM-003, AC-ROOM-004, AC-ROOM-005

**Risikobeschreibung:**  
Wenn zwei Benutzer gleichzeitig den Status desselben Raums ändern, könnte ein Benutzer veraltete Status-Informationen sehen oder eine ungültige Status-Änderung durchführen.

**Beispiel-Szenario:**
1. Benutzer A lädt Raum-Status: `occupied`
2. Benutzer B ändert Status auf `cleaning`
3. Benutzer A versucht, Status auf `available` zu setzen (basierend auf veraltetem `occupied`-Status)
4. Status-Änderung könnte erfolgreich sein, obwohl Übergang `cleaning → available` erlaubt, aber `occupied → available` nicht erlaubt wäre

**Auswirkung:** MITTEL  
Raum könnte in inkorrektem Status angezeigt werden, was zu Verwirrung bei Rezeption führt.

**Eintrittswahrscheinlichkeit:** NIEDRIG  
Tritt nur auf, wenn zwei Benutzer gleichzeitig denselben Raum bearbeiten. In kleinem Hotel mit wenigen Räumen selten.

**Priorität:** NIEDRIG

**Begründung:**  
Auswirkung ist begrenzt (Korrektur möglich, keine Datenverlust-Gefahr). Wahrscheinlichkeit ist niedrig in typischem Anwendungsfall (kleine Hotels, wenige gleichzeitige Benutzer).

**Testvorschläge:**

**Positive Tests:**
- Status-Änderung von `cleaning` auf `available` (AC-ROOM-005)
- Status-Änderung von `available` auf `occupied` (Teil von Check-in)
- Status-Änderung von `occupied` auf `cleaning` (Teil von Check-out)

**Negative Tests:**
- Status-Änderung von `occupied` auf `available` → abgelehnt (AC-ROOM-004)

**Grenzfälle:**
- Gleichzeitige Status-Änderungen desselben Raums durch zwei Benutzer
- Status-Änderung eines nicht-existierenden Raums

---

### R-ROOM-002: Belegter Raum wird versehentlich auf „available" gesetzt

**Betroffene Akzeptanzkriterien:** AC-ROOM-004

**Risikobeschreibung:**  
Falls die Geschäftsregel „belegter Raum kann nur auf `cleaning` gesetzt werden" nicht korrekt implementiert ist, könnte ein belegter Raum versehentlich auf `available` gesetzt werden. Dies würde erlauben, einen bereits belegten Raum erneut einzuchecken (Mehrfach-Belegung).

**Beispiel-Szenario:**
1. Raum 101 hat Status `occupied`, Gast A ist eingecheckt
2. Rezeption versucht versehentlich, Raum 101 auf `available` zu setzen
3. Status-Änderung wird akzeptiert (Bug in Implementierung)
4. Rezeption checkt Gast B in Raum 101 ein
5. Raum ist nun doppelt belegt

**Auswirkung:** HOCH  
Mehrfach-Belegung führt zu ernsthaftem operationalem Problem (zwei Gäste, ein Raum).

**Eintrittswahrscheinlichkeit:** NIEDRIG  
Geschäftsregel ist in Service-Schicht implementiert (`app/services/room_service.py`, Zeilen 20-24). Tritt nur auf, wenn Implementierung fehlerhaft ist oder umgangen wird (z. B. direkte DB-Manipulation).

**Priorität:** MITTEL

**Begründung:**  
Hohe Auswirkung rechtfertigt erhöhte Priorität trotz niedriger Wahrscheinlichkeit. Mehrfach-Belegung ist kritisches Geschäftsproblem.

**Testvorschläge:**

**Positive Tests:**
- Status-Änderung von `occupied` auf `cleaning` wird akzeptiert

**Negative Tests:**
- Status-Änderung von `occupied` auf `available` wird abgelehnt (AC-ROOM-004) — **Priorität: HOCH**

**Grenzfälle:**
- Status-Änderung über verschiedene Zugriffswege (API, direkte DB-Manipulation falls möglich)

---

## 3. Gäste-Management

### R-GUEST-001: Gast mit Zimmerzuweisung wird versehentlich gelöscht

**Betroffene Akzeptanzkriterien:** AC-GUEST-005

**Risikobeschreibung:**  
Falls die Geschäftsregel „Gast mit Zimmerzuweisung kann nicht gelöscht werden" nicht korrekt implementiert ist, könnte ein eingecheckter Gast gelöscht werden. Dies würde zu Dateninkonsistenz führen (Raum hat Status `occupied`, aber kein Gast zugewiesen).

**Beispiel-Szenario:**
1. Gast A ist in Raum 101 eingecheckt (Raum-Status `occupied`)
2. Rezeption versucht, Gast A zu löschen
3. Löschung wird akzeptiert (Bug in Implementierung)
4. Raum 101 hat weiterhin Status `occupied`, aber kein Gast ist zugewiesen

**Auswirkung:** HOCH  
Dateninkonsistenz führt zu operationalen Problemen (Check-out nicht möglich, Raum blockiert).

**Eintrittswahrscheinlichkeit:** NIEDRIG  
Geschäftsregel ist in Service-Schicht implementiert (`app/services/guest_service.py`, Zeilen 26-33). Tritt nur auf, wenn Implementierung fehlerhaft ist.

**Priorität:** MITTEL

**Begründung:**  
Hohe Auswirkung rechtfertigt erhöhte Priorität trotz niedriger Wahrscheinlichkeit. Dateninkonsistenz ist kritisch.

**Testvorschläge:**

**Positive Tests:**
- Gast ohne Zimmerzuweisung löschen wird akzeptiert (AC-GUEST-004)

**Negative Tests:**
- Gast mit Zimmerzuweisung löschen wird abgelehnt (AC-GUEST-005) — **Priorität: HOCH**

**Grenzfälle:**
- Gast löschen unmittelbar nach Check-in
- Gast löschen unmittelbar nach Check-out (sollte erlaubt sein, da `room_id == null`)

---

### R-GUEST-002: Umlaute in Gastnamen werden verstümmelt

**Betroffene Akzeptanzkriterien:** AC-GUEST-006

**Risikobeschreibung:**  
Falls die UTF-8-Unterstützung nicht korrekt funktioniert, könnten Umlaute und Sonderzeichen in Gast-Namen verstümmelt oder entfernt werden (wie vor Version 1.3.1).

**Beispiel-Szenario:**
1. Rezeption legt Gast „Jörg Müller" an
2. Name wird als „Jrg Mller" gespeichert (Umlaute entfernt)
3. Gast beschwert sich über falschen Namen auf Rechnung

**Auswirkung:** MITTEL  
Falscher Name ist unprofessionell und kann zu Kundenbeschwerden führen. Keine kritische Geschäftsprozess-Blockierung.

**Eintrittswahrscheinlichkeit:** NIEDRIG  
Seit Version 1.3.1 ist UTF-8-Unterstützung implementiert (Decision 007). Regression nur bei Code-Änderungen wahrscheinlich.

**Priorität:** NIEDRIG

**Begründung:**  
Feature ist bereits implementiert und getestet (laut Changelog). Regressionstests ausreichend. Keine kritische Auswirkung.

**Testvorschläge:**

**Positive Tests:**
- Gast mit Umlauten anlegen (ä, ö, ü, ß) → korrekte Speicherung (AC-GUEST-006) — **Priorität: MITTEL** (Regressionstest)
- Gast mit französischen Akzenten (é, è, ê, à) → korrekte Speicherung
- Gast mit osteuropäischen Zeichen (ł, ż, ń) → korrekte Speicherung

**Negative Tests:**
- Keine spezifischen negativen Tests erforderlich

**Grenzfälle:**
- Sehr lange Namen mit Sonderzeichen (falls Längenbeschränkung existiert, siehe NA-004)
- Emojis in Namen (falls erlaubt, siehe Frage 4 in Testbasis)

**Annahme:**  
Diese Tests basieren auf der Annahme, dass alle UTF-8-Zeichen erlaubt sind. Testbasis Frage 4 ist offen (Welche Zeichen sind erlaubt?).

---

### R-GUEST-003: Historische Gäste mit verstümmelten Namen

**Betroffene Akzeptanzkriterien:** Keine (Datenqualitäts-Risiko, kein Akzeptanzkriterium)

**Risikobeschreibung:**  
Vor Version 1.3.1 erstellte Gäste haben möglicherweise verstümmelte Namen (z. B. „Jrg" statt „Jörg"). Diese Altdaten wurden nicht migriert.

**Quelle:** `docs/testing/testbasis.md` (Abschnitt 11.5, RISIKO: Historische Gäste mit korrupten Umlauten)

**Auswirkung:** NIEDRIG  
Betrifft nur historische Daten. Neue Gäste werden korrekt gespeichert. Altdaten können manuell korrigiert werden (AC-GUEST-003).

**Eintrittswahrscheinlichkeit:** HOCH (falls Anwendung vor Version 1.3.1 produktiv genutzt wurde)  
Aber: Für Trainingsprojekt irrelevant (keine produktive Nutzung vor Version 1.3.1).

**Priorität:** NIEDRIG

**Begründung:**  
Bekanntes Problem, dokumentiert in Changelog. Für Trainingsprojekt akzeptabel. In Produktivsystem würde manuelle Daten-Bereinigung erforderlich sein.

**Testvorschläge:**

**Positive Tests:**
- Gast mit verstümmeltem Namen anzeigen (keine Fehlermeldung)
- Gast mit verstümmeltem Namen bearbeiten und korrigieren (AC-GUEST-003)

**Negative Tests:**
- Keine

**Grenzfälle:**
- Such-Funktion mit verstümmelten Namen (falls Such-Feature existiert)

---

## 4. Check-in / Check-out

### R-CHECKIN-001: Mehrfach-Check-in bei gleichzeitigen Check-ins

**Betroffene Akzeptanzkriterien:** AC-CHECKIN-001, AC-CHECKIN-002, AC-CHECKIN-003

**Risikobeschreibung:**  
Wenn zwei Benutzer gleichzeitig versuchen, verschiedene Gäste in denselben Raum einzuchecken, könnte der Raum zweimal vergeben werden (Race Condition).

**Quelle:** `docs/testing/testbasis.md` (Abschnitt 11.2, RISIKO: Mehrfach-Check-in bei Race Conditions)

**Beispiel-Szenario:**
1. Raum 101 hat Status `available`
2. Benutzer A startet Check-in für Gast A in Raum 101
3. Benutzer B startet Check-in für Gast B in Raum 101 (gleichzeitig, bevor A abgeschlossen ist)
4. Beide Check-ins prüfen Status `available` → beide erfolgreich
5. Raum 101 ist nun doppelt belegt (Gast A und Gast B)

**Auswirkung:** HOCH  
Mehrfach-Belegung ist kritisches operationales Problem.

**Eintrittswahrscheinlichkeit:** NIEDRIG  
Tritt nur auf, wenn zwei Benutzer exakt gleichzeitig denselben Raum einchecken. In kleinem Hotel mit wenigen Räumen und Benutzern selten.

**Annahme zur Wahrscheinlichkeit:**  
Diese Bewertung basiert auf der Annahme, dass die Anwendung in einem kleinen Hotel mit wenigen gleichzeitigen Benutzern eingesetzt wird. In größerem Hotel oder bei automatisierten Check-ins (z. B. Self-Service-Terminals) wäre Wahrscheinlichkeit HOCH.

**Priorität:** MITTEL

**Begründung:**  
Hohe Auswirkung rechtfertigt erhöhte Priorität trotz niedriger Wahrscheinlichkeit. Keine explizite Transaktion mit Lock in Implementierung dokumentiert (`app/services/checkinout_service.py`).

**Testvorschläge:**

**Positive Tests:**
- Gast einem verfügbaren Raum zuweisen (AC-CHECKIN-001)
- Check-in nur für verfügbare Räume (AC-CHECKIN-002)
- Gast kann nur einem Raum zugewiesen sein (AC-CHECKIN-003)

**Negative Tests:**
- Check-in in Raum mit Status `occupied` wird abgelehnt
- Check-in in Raum mit Status `cleaning` wird abgelehnt
- Check-in für Gast, der bereits eingecheckt ist, wird abgelehnt

**Grenzfälle:**
- **Gleichzeitige Check-ins desselben Raums durch zwei Benutzer (Concurrency-Test)** — **Priorität: HOCH**
- Check-in unmittelbar nach Status-Änderung von `cleaning` auf `available`

**Annahme:**  
Concurrency-Tests erfordern spezielle Test-Infrastruktur (z. B. Threading, parallele API-Aufrufe). Dies wurde als hohes Risiko eingestuft, auch wenn Wahrscheinlichkeit im Trainingsprojekt niedrig ist.

---

### R-CHECKIN-002: Raum bleibt im Status „cleaning" nach Check-out

**Betroffene Akzeptanzkriterien:** AC-CHECKIN-004, AC-CHECKIN-006

**Risikobeschreibung:**  
Falls Check-out den Raum-Status nicht korrekt auf `cleaning` setzt, könnte der Raum im falschen Status verbleiben (z. B. `occupied` oder `available`).

**Beispiel-Szenario (Status bleibt `occupied`):**
1. Gast A checkt aus
2. Raum-Status bleibt `occupied` (Bug in Implementierung)
3. Raum kann nicht erneut eingecheckt werden (korrekt, aber aus falschem Grund)
4. Rezeption kann Raum nicht auf `available` setzen (da `occupied → available` blockiert ist)
5. Raum ist operativ blockiert

**Beispiel-Szenario (Status wird `available`):**
1. Gast A checkt aus
2. Raum-Status wird direkt `available` gesetzt (Bug in Implementierung, siehe Decision 003 vs. 009)
3. Rezeption checkt Gast B ein, bevor Raum gereinigt wurde
4. Gast B beschwert sich über schmutzigen Raum

**Auswirkung:** HOCH  
Falscher Raum-Status führt zu operationalen Problemen oder Kundenunzufriedenheit.

**Eintrittswahrscheinlichkeit:** NIEDRIG  
Ein Unit-Test existiert bereits (`tests/test_checkout_service.py`), der `cleaning`-Status nach Check-out prüft. Regression nur bei Code-Änderungen wahrscheinlich.

**Priorität:** MITTEL

**Begründung:**  
Hohe Auswirkung rechtfertigt erhöhte Priorität. Kein API-Integrationstest vorhanden (laut Testbasis), daher Regressionsgefahr bei API-Layer-Änderungen.

**Testvorschläge:**

**Positive Tests:**
- Check-out setzt Raum auf `cleaning` (AC-CHECKIN-004) — **Priorität: HOCH** (API-Integrationstest erforderlich)
- Raum nach Check-out nicht sofort für Check-in verfügbar (AC-CHECKIN-006)

**Negative Tests:**
- Check-out für Gast ohne Zimmerzuweisung wird abgelehnt (AC-CHECKIN-005)

**Grenzfälle:**
- Check-out unmittelbar nach Check-in
- Check-out und sofortiger Versuch, Raum einzuchecken (sollte abgelehnt werden)

---

### R-CHECKIN-003: Gast kann nicht ausgecheckt werden

**Betroffene Akzeptanzkriterien:** AC-CHECKIN-005

**Risikobeschreibung:**  
Falls die Geschäftsregel „Gast ohne Zimmerzuweisung kann nicht ausgecheckt werden" zu restriktiv ist, könnte ein legitimer Check-out blockiert werden.

**Beispiel-Szenario:**
1. Gast A ist in Raum 101 eingecheckt
2. Durch Fehler (z. B. manuelle DB-Änderung) wird `room_id` auf `null` gesetzt
3. Rezeption versucht, Gast A auszuchecken
4. Check-out wird abgelehnt (korrekt gemäß AC-CHECKIN-005, aber Gast ist operativ „eingecheckt")
5. Rezeption kann Gast-Daten nicht bereinigen

**Auswirkung:** NIEDRIG  
Manuelle Korrektur möglich (Gast erneut einchecken, dann auschecken). Tritt nur bei manueller DB-Manipulation oder Bug auf.

**Eintrittswahrscheinlichkeit:** NIEDRIG  
Tritt nur bei manueller DB-Manipulation oder schwerwiegendem Bug auf.

**Priorität:** NIEDRIG

**Begründung:**  
Niedrige Auswirkung und niedrige Wahrscheinlichkeit. Geschäftsregel ist sinnvoll und konsistent.

**Annahme:**  
Diese Bewertung basiert auf der Annahme, dass manuelle DB-Manipulation im Normalbetrieb nicht vorkommt. Falls DB-Direktzugriff Teil des operativen Workflows ist, wäre Wahrscheinlichkeit höher.

**Testvorschläge:**

**Positive Tests:**
- Check-out für eingecheckten Gast (AC-CHECKIN-004)

**Negative Tests:**
- Check-out für Gast ohne Zimmerzuweisung wird abgelehnt (AC-CHECKIN-005)

**Grenzfälle:**
- Check-out für Gast, dessen `room_id` manuell auf `null` gesetzt wurde (Edge-Case, nicht in Spezifikation)

---

### R-CHECKIN-004: Gast wird mehreren Räumen zugewiesen

**Betroffene Akzeptanzkriterien:** AC-CHECKIN-003

**Risikobeschreibung:**  
Falls die Geschäftsregel „Gast kann nur einem Raum zugewiesen sein" nicht korrekt implementiert ist, könnte ein Gast mehreren Räumen zugewiesen werden.

**Quelle:** Testbasis Frage 7 (Ist ein direkter Check-in ohne vorherigen Check-out erlaubt — Zimmerwechsel?)

**Beispiel-Szenario:**
1. Gast A ist in Raum 101 eingecheckt
2. Rezeption versucht, Gast A in Raum 102 einzuchecken (Zimmerwechsel)
3. Check-in wird akzeptiert (Bug in Implementierung)
4. Gast A ist nun beiden Räumen zugewiesen (Raum 101 und 102 haben Status `occupied`)

**Auswirkung:** HOCH  
Dateninkonsistenz führt zu operationalen Problemen (zwei Räume blockiert für einen Gast).

**Eintrittswahrscheinlichkeit:** NIEDRIG  
Geschäftsregel ist in Service-Schicht implementiert (`app/services/checkinout_service.py`, Zeilen 12-13). Tritt nur auf, wenn Implementierung fehlerhaft ist.

**Priorität:** MITTEL

**Begründung:**  
Hohe Auswirkung rechtfertigt erhöhte Priorität trotz niedriger Wahrscheinlichkeit.

**Testvorschläge:**

**Positive Tests:**
- Gast kann einem Raum zugewiesen werden, wenn noch nicht eingecheckt (AC-CHECKIN-001)

**Negative Tests:**
- Gast, der bereits eingecheckt ist, kann nicht erneut eingecheckt werden (AC-CHECKIN-003) — **Priorität: HOCH**

**Grenzfälle:**
- Check-in für Gast unmittelbar nach Check-out (sollte erlaubt sein)
- Zimmerwechsel-Workflow (unklar, ob erlaubt — siehe Testbasis Frage 7)

**Annahme:**  
Diese Tests basieren auf der Annahme, dass Zimmerwechsel einen expliziten Check-out + Check-in erfordert. Falls Zimmerwechsel ohne Check-out erlaubt sein soll, ist dies eine offene fachliche Frage (Testbasis Frage 7).

---

## 5. Messaging

### R-MSG-001: Nachricht wird nicht gespeichert

**Betroffene Akzeptanzkriterien:** AC-MSG-001, AC-MSG-013, AC-MSG-014

**Risikobeschreibung:**  
Falls Nachrichten nicht korrekt in der Datenbank gespeichert werden, gehen Nachrichten verloren.

**Beispiel-Szenario:**
1. Rezeption sendet Nachricht an Raum 101
2. Nachricht wird nicht in Datenbank gespeichert (Bug)
3. Nachricht ist nach Anwendungsneustart verloren
4. Gast erhält keine wichtige Information (z. B. Check-out-Zeit)

**Auswirkung:** HOCH  
Nachrichtenverlust kann zu operationalen Problemen führen (Gast nicht informiert).

**Eintrittswahrscheinlichkeit:** NIEDRIG  
Persistenz ist grundlegende Funktion, die in SQLite-Datenbank implementiert ist. Fehler nur bei schwerwiegendem Bug.

**Priorität:** MITTEL

**Begründung:**  
Hohe Auswirkung rechtfertigt erhöhte Priorität trotz niedriger Wahrscheinlichkeit. Nachrichtenpersistenz ist Kern-Anforderung (AC-MSG-013, AC-MSG-014).

**Testvorschläge:**

**Positive Tests:**
- Nachricht erstellen und speichern (AC-MSG-001) — **Priorität: HOCH**
- Nachricht nach Anwendungsneustart abrufen (AC-MSG-014) — **Priorität: HOCH**

**Negative Tests:**
- Nachricht an nicht-existenten Raum senden wird abgelehnt

**Grenzfälle:**
- Nachricht mit sehr langem Inhalt (falls Längenbeschränkung existiert)
- Nachricht mit Sonderzeichen (HTML, SQL-Injection-Versuche — siehe R-SEC-001)

---

### R-MSG-002: Nachrichtenstatus wird inkorrekt geändert

**Betroffene Akzeptanzkriterien:** AC-MSG-010, AC-MSG-011, AC-MSG-012

**Risikobeschreibung:**  
Falls die Geschäftsregel „Status schreitet nur vorwärts" nicht korrekt implementiert ist, könnten ungültige Status-Übergänge (Rückwärts, Überspringen) akzeptiert werden.

**Beispiel-Szenario (Rückwärts):**
1. Nachricht hat Status `delivered`
2. Rezeption ändert Status auf `sent` (Fehler oder Bug)
3. Status-Änderung wird akzeptiert (Bug in Implementierung)
4. Rezeption sieht inkorrekte Status-Historie

**Beispiel-Szenario (Überspringen):**
1. Nachricht hat Status `sent`
2. Rezeption ändert Status direkt auf `read` (überspringt `delivered`)
3. Status-Änderung wird akzeptiert (Bug in Implementierung)
4. Status `delivered` wird nie erreicht (inkorrekte Tracking-Daten)

**Auswirkung:** MITTEL  
Inkorrekte Status-Werte führen zu Verwirrung und ungenauen Tracking-Daten. Keine kritische Geschäftsprozess-Blockierung.

**Eintrittswahrscheinlichkeit:** NIEDRIG  
Geschäftsregel ist in Service-Schicht mit expliziter Zustandsübergangstabelle implementiert (`app/services/message_service.py`, Zeilen 7-11). Fehler nur bei schwerwiegendem Bug.

**Priorität:** NIEDRIG

**Begründung:**  
Mittlere Auswirkung und niedrige Wahrscheinlichkeit. Geschäftsregel ist klar definiert und implementiert.

**Testvorschläge:**

**Positive Tests:**
- Status-Änderung `sent → delivered` (AC-MSG-011)
- Status-Änderung `delivered → read` (AC-MSG-012)

**Negative Tests:**
- Status-Änderung `delivered → sent` wird abgelehnt (Rückwärts) — **Priorität: MITTEL**
- Status-Änderung `sent → read` wird abgelehnt (Überspringen) — **Priorität: MITTEL**
- Status-Änderung `read → delivered` wird abgelehnt (Rückwärts)
- Status-Änderung `read → sent` wird abgelehnt (Rückwärts)

**Grenzfälle:**
- Gleichzeitige Status-Änderungen derselben Nachricht durch zwei Benutzer (Race Condition)

---

### R-MSG-003: Nachrichten-Filter nach Raum zeigt falsche Nachrichten

**Betroffene Akzeptanzkriterien:** AC-MSG-005, AC-MSG-007

**Risikobeschreibung:**  
Falls der Filter nach Raum nicht korrekt implementiert ist, könnten Nachrichten des falschen Raums angezeigt werden.

**Beispiel-Szenario:**
1. Raum 101 hat Nachrichten „Welcome" und „Breakfast at 8am"
2. Raum 102 hat Nachricht „Room service available"
3. Rezeption filtert nach Raum 101
4. Liste zeigt auch Nachricht „Room service available" von Raum 102 (Bug)
5. Rezeption ist verwirrt über falsche Nachrichten

**Auswirkung:** MITTEL  
Falsche Nachrichten führen zu Verwirrung. Keine kritische Geschäftsprozess-Blockierung.

**Eintrittswahrscheinlichkeit:** NIEDRIG  
Filter-Funktionalität ist grundlegende Anforderung. Fehler nur bei schwerwiegendem Bug.

**Priorität:** NIEDRIG

**Begründung:**  
Mittlere Auswirkung und niedrige Wahrscheinlichkeit. Filter-Funktionalität ist einfach zu implementieren und testen.

**Testvorschläge:**

**Positive Tests:**
- Alle Nachrichten anzeigen (AC-MSG-004)
- Nachrichten nach Raum filtern (AC-MSG-005) — **Priorität: HOCH**
- Gast zeigt nur Nachrichten des eigenen Raums (AC-MSG-007) — **Priorität: HOCH**

**Negative Tests:**
- Filter nach nicht-existentem Raum (leere Liste oder Fehler)

**Grenzfälle:**
- Filter nach Raum ohne Nachrichten (leere Liste)
- Filter mit ungültigem Raum-ID-Format (z. B. Buchstaben statt Zahlen)

---

### R-MSG-004: Gast sieht Nachrichten anderer Räume

**Betroffene Akzeptanzkriterien:** AC-MSG-007

**Risikobeschreibung:**  
Falls die Gastsicht nicht korrekt nach Raum filtert, könnte ein Gast Nachrichten anderer Räume sehen (Datenschutz-Problem).

**Quelle:** `docs/testing/testbasis.md` (Abschnitt 11.1, RISIKO: Keine Authentifizierung / Autorisierung)

**Beispiel-Szenario:**
1. Raum 101 hat private Nachricht „Your bill is overdue"
2. Gast in Raum 102 ruft Gastsicht mit `room_id=101` auf
3. Gast sieht Nachricht „Your bill is overdue" (Bug oder Design-Problem)
4. Datenschutz-Verletzung

**Auswirkung:** HOCH  
Datenschutz-Verletzung ist ernsthaftes Problem, auch in Trainingsprojekt ohne echte Daten.

**Eintrittswahrscheinlichkeit:** MITTEL  
Gastsicht ist unauthenticated (laut Decision 008). Jeder mit Kenntnis einer Raum-ID kann Nachrichten sehen. Kein Bug, sondern bekannte Design-Limitation.

**Annahme zur Wahrscheinlichkeit:**  
Diese Bewertung basiert auf der Annahme, dass Gäste normalerweise nur ihre eigene Raum-ID kennen. Falls Raum-IDs leicht erratbar sind (z. B. 1, 2, 3, ...), ist Wahrscheinlichkeit HOCH.

**Priorität:** HOCH

**Begründung:**  
Hohe Auswirkung und mittlere Wahrscheinlichkeit. Bekannte Design-Limitation (keine Authentifizierung), aber dennoch Risiko für Datenschutz.

**Testvorschläge:**

**Positive Tests:**
- Gast mit gültiger `room_id` sieht nur Nachrichten dieses Raums (AC-MSG-007)

**Negative Tests:**
- Keine (Design-Limitation, nicht Bug)

**Grenzfälle:**
- **Gast mit `room_id` eines anderen Raums kann Nachrichten sehen** — **Priorität: HOCH** (Datenschutz-Test)
- Gast mit ungültiger `room_id` (nicht-existenter Raum)

**Annahme:**  
Diese Tests basieren auf der Annahme, dass unauthenticated Zugriff eine akzeptierte Design-Limitation ist (gemäß Decision 008 und Scope Boundaries). Falls Datenschutz-Anforderungen verschärft werden, ist Redesign erforderlich.

---

### R-MSG-005: Auto-Delivery setzt Status inkorrekt

**Betroffene Akzeptanzkriterien:** AC-MSG-011 (indirekt, Auto-Delivery ist nicht in Akzeptanzkriterien, da NA-001)

**Risikobeschreibung:**  
Falls der Auto-Delivery-Mechanismus nicht korrekt implementiert ist, könnten Nachrichten fälschlicherweise auf `delivered` gesetzt werden (z. B. auch Gast-Nachrichten, die vom Gast selbst stammen).

**Quelle:** `docs/testing/testbasis.md` (Abschnitt 8.2, Annahme: Auto-Delivery-Definition)

**Beispiel-Szenario:**
1. Gast sendet Nachricht „Can I have extra towels?"
2. Gast lädt Gastsicht neu
3. Auto-Delivery setzt eigene Nachricht auf `delivered` (Bug)
4. Nachricht erscheint als „delivered", obwohl sie vom Gast selbst stammt (verwirrend)

**Auswirkung:** NIEDRIG  
Verwirrende Anzeige, aber keine operationale Auswirkung.

**Eintrittswahrscheinlichkeit:** NIEDRIG  
Auto-Delivery prüft explizit, ob Nachricht vom Gast stammt (`!isFromGuest(m.sender)`, `static/js/guest_messages.js`, Zeile 44). Fehler nur bei Bug.

**Priorität:** NIEDRIG

**Begründung:**  
Niedrige Auswirkung und niedrige Wahrscheinlichkeit. Feature ist Implementierung (nicht in Spezifikation), aber konsistent implementiert.

**Annahme:**  
Diese Bewertung basiert auf der Annahme, dass Auto-Delivery-Mechanismus fachlich korrekt ist (siehe NA-001 in Akzeptanzkriterien). Falls fachliche Definition von „delivered" anders ist, wäre Priorität höher.

**Testvorschläge:**

**Positive Tests:**
- Gastsicht lädt Rezeptionsnachrichten mit Status `sent` → automatisch auf `delivered` gesetzt
- Gastsicht lädt eigene Nachrichten mit Status `sent` → Status bleibt `sent` (nicht auto-delivered)

**Negative Tests:**
- Keine

**Grenzfälle:**
- Viele Nachrichten mit Status `sent` (Performance-Test, siehe R-PERF-001)
- Parallele Gastsicht-Aufrufe (Race Condition, siehe R-PERF-001)

---

## 6. Sicherheit (übergreifend)

### R-SEC-001: Cross-Site-Scripting (XSS) in Nachrichteninhalt

**Betroffene Akzeptanzkriterien:** AC-MSG-001, AC-MSG-004, AC-MSG-006, AC-MSG-007

**Risikobeschreibung:**  
Falls Nachrichteninhalte nicht korrekt escaped werden, könnte ein Angreifer JavaScript-Code in Nachrichten einschleusen, der beim Anzeigen ausgeführt wird.

**Quelle:** `docs/testing/testbasis.md` (Abschnitt 11.1, RISIKO: Keine Authentifizierung / Autorisierung)

**Beispiel-Szenario:**
1. Angreifer sendet Nachricht mit Inhalt `<script>alert('XSS')</script>`
2. Rezeption oder Gast öffnet Nachrichtenansicht
3. JavaScript-Code wird ausgeführt (Browser zeigt Alert)
4. In echtem Angriff: Cookie-Diebstahl, Session-Hijacking, etc.

**Auswirkung:** HOCH  
XSS-Angriffe können zu Session-Hijacking, Datendiebstahl und weiteren Sicherheitsproblemen führen.

**Eintrittswahrscheinlichkeit:** MITTEL  
Kein HTML-Escaping dokumentiert. Framework (FastAPI, Vanilla JS) bietet keinen automatischen Schutz in Plain-HTML-Rendering.

**Annahme zur Wahrscheinlichkeit:**  
Diese Bewertung basiert auf der Annahme, dass kein explizites HTML-Escaping implementiert ist. Falls Framework oder Implementierung automatisch escaped, ist Wahrscheinlichkeit NIEDRIG.

**Priorität:** HOCH

**Begründung:**  
Hohe Auswirkung und mittlere Wahrscheinlichkeit. XSS ist OWASP Top 10 Sicherheitsrisiko.

**Testvorschläge:**

**Positive Tests:**
- Nachricht mit normalem Text (Buchstaben, Zahlen, Satzzeichen)
- Nachricht mit Umlauten und Sonderzeichen (z. B. ä, ö, ü, €, @)

**Negative Tests:**
- Keine (XSS ist Sicherheitsrisiko, nicht Geschäftsregel-Verletzung)

**Grenzfälle / Sicherheitstests:**
- **Nachricht mit HTML-Tags (z. B. `<b>bold</b>`) → Tags werden escaped oder entfernt, nicht gerendert** — **Priorität: KRITISCH**
- **Nachricht mit Script-Tag (z. B. `<script>alert('XSS')</script>`) → Code wird nicht ausgeführt** — **Priorität: KRITISCH**
- **Nachricht mit Event-Handler (z. B. `<img src=x onerror="alert('XSS')">`) → Code wird nicht ausgeführt** — **Priorität: KRITISCH**
- Nachricht mit SQL-Injection-Versuch (z. B. `'; DROP TABLE messages; --`) → keine SQL-Injection (SQLAlchemy ORM sollte schützen)

**Annahme:**  
Diese Tests basieren auf der Annahme, dass XSS-Schutz erforderlich ist, auch wenn keine Authentifizierung existiert. OWASP Best Practices empfehlen immer HTML-Escaping für User-Generated Content.

---

### R-SEC-002: SQL-Injection in Such-/Filterfeldern

**Betroffene Akzeptanzkriterien:** AC-MSG-005, AC-ROOM-001, AC-GUEST-002

**Risikobeschreibung:**  
Falls Such- oder Filterfelder nicht korrekt parametrisiert sind, könnte ein Angreifer SQL-Injection-Angriffe durchführen.

**Quelle:** `docs/testing/testbasis.md` (Abschnitt 11.1, RISIKO: Keine Authentifizierung / Autorisierung)

**Beispiel-Szenario:**
1. Angreifer filtert Nachrichten mit manipuliertem `room_id`: `1 OR 1=1`
2. SQL-Query wird fehlerhaft generiert: `SELECT * FROM messages WHERE room_id = 1 OR 1=1`
3. Alle Nachrichten werden zurückgegeben (statt nur Raum 1)
4. In echtem Angriff: Datenbank-Manipulation, Datendiebstahl, etc.

**Auswirkung:** HOCH  
SQL-Injection kann zu Datendiebstahl, Datenmanipulation und Datenverlust führen.

**Eintrittswahrscheinlichkeit:** NIEDRIG  
SQLAlchemy ORM wird verwendet, das automatisch parametrisierte Queries generiert. SQL-Injection nur bei unsicherer Raw-SQL-Nutzung möglich.

**Priorität:** MITTEL

**Begründung:**  
Hohe Auswirkung rechtfertigt erhöhte Priorität trotz niedriger Wahrscheinlichkeit. SQL-Injection ist OWASP Top 10 Sicherheitsrisiko.

**Testvorschläge:**

**Positive Tests:**
- Filter nach Raum mit gültiger Raum-ID (Zahl)
- Suche nach Gast mit normalem Namen

**Negative Tests:**
- Keine (SQL-Injection ist Sicherheitsrisiko, nicht Geschäftsregel-Verletzung)

**Grenzfälle / Sicherheitstests:**
- **Filter mit SQL-Injection-Versuch (z. B. `room_id=1 OR 1=1`) → keine Daten-Leakage** — **Priorität: HOCH**
- **Filter mit SQL-Kommentar (z. B. `room_id=1--`) → keine Daten-Leakage** — **Priorität: HOCH**
- Filter mit Sonderzeichen (z. B. `'`, `"`, `;`) → keine Fehler oder Daten-Leakage

**Annahme:**  
Diese Tests basieren auf der Annahme, dass SQLAlchemy ORM korrekt verwendet wird. Falls Raw-SQL verwendet wird, ist Wahrscheinlichkeit HOCH.

---

### R-SEC-003: Sender-Impersonation

**Betroffene Akzeptanzkriterien:** AC-MSG-001 (indirekt, Sender ist Freitext, siehe NA-003)

**Risikobeschreibung:**  
Da das Sender-Feld Freitext ist, kann jeder beliebige Sender-Namen setzen. Gast könnte sich als „Reception" ausgeben.

**Quelle:** `docs/testing/testbasis.md` (Abschnitt 11.1, RISIKO: Sender-Impersonation)

**Beispiel-Szenario:**
1. Gast sendet Nachricht mit `sender="Reception"` (statt „Guest (Room 101)")
2. Nachricht wird akzeptiert und gespeichert
3. Andere Gäste oder Rezeption sehen Nachricht als von „Reception" stammend
4. Verwirrung oder Missbrauch möglich (z. B. falsche Anweisungen)

**Auswirkung:** MITTEL  
Verwirrung und potenzieller Missbrauch. Keine kritische Sicherheitslücke (keine Authentifizierung erwartet).

**Eintrittswahrscheinlichkeit:** HOCH  
Sender-Feld ist Freitext ohne Validierung (bekannte Design-Limitation, siehe Decision 006).

**Priorität:** HOCH

**Begründung:**  
Mittlere Auswirkung und hohe Wahrscheinlichkeit. Bekannte Design-Limitation, aber dennoch Risiko für Missbrauch.

**Annahme:**  
Diese Bewertung basiert auf der Annahme, dass Sender-Impersonation ein Problem ist. Falls Freitext-Sender akzeptierte Design-Entscheidung ist (gemäß Decision 006), ist dies kein Fehler, sondern bekannte Limitation.

**Testvorschläge:**

**Positive Tests:**
- Rezeption sendet Nachricht mit Sender „Reception" (Standard-Wert)
- Gast sendet Nachricht mit automatisch gesetztem Sender „Guest (Room {number})"

**Negative Tests:**
- Keine (Design-Limitation, nicht Bug)

**Grenzfälle:**
- **Gast sendet Nachricht mit manipuliertem Sender „Reception"** — **Priorität: HOCH** (Impersonation-Test)
- Nachricht mit sehr langem Sender-Namen (falls Längenbeschränkung existiert)
- Nachricht mit Sonderzeichen im Sender-Namen (HTML, Script-Tags — siehe R-SEC-001)

**Annahme:**  
Diese Tests basieren auf der Annahme, dass Sender-Impersonation ein Risiko ist. Falls fachliche Klärung ergibt, dass Freitext-Sender akzeptabel ist, ist dies kein Test-Fehler, sondern dokumentierte Limitation.

---

## 7. Performance (übergreifend)

### R-PERF-001: Performance-Probleme bei vielen Nachrichten

**Betroffene Akzeptanzkriterien:** AC-MSG-004, AC-MSG-005, AC-MSG-007

**Risikobeschreibung:**  
Falls keine Pagination oder Limitierung existiert, könnte das Laden aller Nachrichten (insbesondere gefiltert nach Raum) bei großer Nachrichtenanzahl zu Performance-Problemen führen.

**Quelle:** `docs/testing/testbasis.md` (Abschnitt 11.4, RISIKO: Unbegrenzte Nachrichten-Historie)

**Beispiel-Szenario:**
1. Raum 101 hat 10.000 Nachrichten (nach jahrelanger Nutzung)
2. Gast oder Rezeption öffnet Nachrichtenansicht für Raum 101
3. Frontend lädt alle 10.000 Nachrichten
4. Browser wird langsam oder friert ein
5. Auto-Delivery führt 10.000 PATCH-Requests aus (siehe R-MSG-005)

**Auswirkung:** MITTEL  
Langsame oder unbrauchbare Anwendung. Keine Datenverlust-Gefahr.

**Eintrittswahrscheinlichkeit:** NIEDRIG (kurzfristig), HOCH (langfristig)  
Tritt erst nach längerer Nutzung auf (tausende Nachrichten). Für Trainingsprojekt irrelevant.

**Priorität:** NIEDRIG (für Trainingsprojekt), HOCH (für Produktivsystem)

**Begründung:**  
Für Trainingsprojekt mit wenigen Test-Nachrichten ist Performance kein Problem. Für Produktivsystem würde Pagination erforderlich sein.

**Annahme zur Priorität:**  
Diese Bewertung basiert auf der Annahme, dass die Anwendung als Trainingsprojekt mit kleiner Datenmenge betrieben wird. Falls Produktiv-Einsatz geplant ist, wäre Priorität HOCH.

**Testvorschläge:**

**Positive Tests:**
- Nachrichten anzeigen mit kleiner Anzahl (z. B. 10 Nachrichten)
- Nachrichten filtern mit kleiner Anzahl

**Negative Tests:**
- Keine

**Grenzfälle / Performance-Tests:**
- **Nachrichten anzeigen mit großer Anzahl (z. B. 1000+ Nachrichten)** — **Priorität: MITTEL** (Performance-Test)
- **Auto-Delivery mit vielen `sent`-Nachrichten (z. B. 100+)** — **Priorität: MITTEL** (Performance-Test)
- **Parallele Gastsicht-Aufrufe auf selben Raum (Race Condition)** — **Priorität: NIEDRIG**

---

### R-PERF-002: N+1-Problem bei Nachrichten-Liste

**Betroffene Akzeptanzkriterien:** AC-MSG-004, AC-MSG-005

**Risikobeschreibung:**  
Falls Nachrichten-Repository `room`-Objekte lazy-loaded (statt eager-loaded), könnte bei großer Nachrichtenanzahl ein N+1-Query-Problem entstehen (eine Query für Nachrichten-Liste + N Queries für Raum-Details).

**Quelle:** `docs/testing/testbasis.md` (Abschnitt 11.4, RISIKO: N+1-Problem bei Nachrichten-Liste)

**Beispiel-Szenario:**
1. 1000 Nachrichten existieren
2. API-Endpunkt `/api/messages` wird aufgerufen
3. SQLAlchemy führt 1 Query für Nachrichten aus + 1000 Queries für Raum-Details
4. Datenbank-Performance wird schlecht

**Auswirkung:** NIEDRIG  
Langsame API-Response. Keine Datenverlust-Gefahr.

**Eintrittswahrscheinlichkeit:** NIEDRIG  
Tritt nur bei großer Nachrichtenanzahl auf. N+1-Problem ist bekanntes ORM-Pattern, das vermieden werden kann (Eager Loading).

**Priorität:** NIEDRIG

**Begründung:**  
Niedrige Auswirkung und niedrige Wahrscheinlichkeit. Für Trainingsprojekt irrelevant. In Produktivsystem würde Query-Optimierung erforderlich sein.

**Annahme:**  
Diese Bewertung basiert auf der Annahme, dass Implementierung kein explizites Eager Loading nutzt. Code-Review von `app/repositories/message_repository.py` erforderlich, um zu bestätigen.

**Testvorschläge:**

**Positive Tests:**
- Keine spezifischen Tests (Code-Review erforderlich)

**Negative Tests:**
- Keine

**Grenzfälle / Performance-Tests:**
- **DB-Query-Count messen bei großer Nachrichtenanzahl (z. B. 1000+)** — **Priorität: NIEDRIG** (Profiling-Test)

---

## 8. Zusammenfassung und Priorisierung

### 8.1 Risiken nach Priorität

**KRITISCHE Risiken (Tests erforderlich):**
- R-SEC-001: XSS in Nachrichteninhalt (3 Tests, alle KRITISCH)

**HOHE Risiken (Tests erforderlich):**
- R-CHECKIN-001: Mehrfach-Check-in bei Race Conditions (1 Concurrency-Test)
- R-CHECKIN-002: Check-out setzt Raum nicht auf „cleaning" (1 API-Integrationstest)
- R-ROOM-002: Belegter Raum auf „available" gesetzt (1 negativer Test)
- R-GUEST-001: Gast mit Zimmerzuweisung gelöscht (1 negativer Test)
- R-CHECKIN-004: Gast mehreren Räumen zugewiesen (1 negativer Test)
- R-MSG-001: Nachricht nicht gespeichert (2 positive Tests)
- R-MSG-003: Filter zeigt falsche Nachrichten (2 positive Tests)
- R-MSG-004: Gast sieht Nachrichten anderer Räume (1 Datenschutz-Test)
- R-SEC-002: SQL-Injection (2 Sicherheitstests)
- R-SEC-003: Sender-Impersonation (1 Impersonation-Test)

**MITTLERE Risiken:**
- R-GUEST-002: Umlaute verstümmelt (1 Regressionstest)
- R-MSG-002: Nachrichtenstatus inkorrekt geändert (2 negative Tests)
- R-PERF-001: Performance-Probleme bei vielen Nachrichten (2 Performance-Tests)

**NIEDRIGE Risiken:**
- R-ROOM-001: Inkorrekte Status-Anzeige bei gleichzeitigen Änderungen
- R-GUEST-003: Historische Gäste mit verstümmelten Namen
- R-CHECKIN-003: Gast kann nicht ausgecheckt werden
- R-MSG-005: Auto-Delivery setzt Status inkorrekt
- R-PERF-002: N+1-Problem bei Nachrichten-Liste

### 8.2 Empfohlene Test-Priorisierung

**Phase 1 — Kritische Sicherheits- und Datenintegritäts-Tests (sofort):**
1. R-SEC-001: XSS-Tests (3 Tests) — **KRITISCH**
2. R-ROOM-002: Belegter Raum nicht auf „available" (1 Test) — **HOCH**
3. R-GUEST-001: Gast mit Zimmerzuweisung nicht löschen (1 Test) — **HOCH**
4. R-CHECKIN-004: Gast nur einem Raum zuweisen (1 Test) — **HOCH**
5. R-CHECKIN-002: Check-out setzt Raum auf „cleaning" (1 API-Test) — **HOCH**

**Phase 2 — Funktionale Kern-Tests (nächste Priorität):**
6. R-MSG-001: Nachrichtenpersistenz (2 Tests) — **HOCH**
7. R-MSG-003: Filter korrekt (2 Tests) — **HOCH**
8. R-MSG-004: Gast-Datenschutz (1 Test) — **HOCH**
9. R-SEC-002: SQL-Injection-Tests (2 Tests) — **HOCH**
10. R-SEC-003: Sender-Impersonation (1 Test) — **HOCH**

**Phase 3 — Positive Akzeptanztests (alle Akzeptanzkriterien abdecken):**
11. Alle AC-ROOM-NNN (5 Akzeptanzkriterien)
12. Alle AC-GUEST-NNN (6 Akzeptanzkriterien)
13. Alle AC-CHECKIN-NNN (6 Akzeptanzkriterien)
14. Alle AC-MSG-NNN (14 Akzeptanzkriterien)

**Phase 4 — Erweiterte Tests (bei Bedarf):**
15. R-CHECKIN-001: Concurrency-Tests (1 Test) — **HOCH** (aber aufwändiger)
16. R-GUEST-002: UTF-8-Regressionstests (3 Tests) — **MITTEL**
17. R-MSG-002: Negative Status-Übergänge (4 Tests) — **MITTEL**
18. R-PERF-001: Performance-Tests (3 Tests) — **NIEDRIG bis MITTEL**

### 8.3 Fachliche Annahmen in Risikobewertung

Folgende Risikobewertungen enthalten fachliche Annahmen, die Klärung erfordern:

**R-CHECKIN-001 (Mehrfach-Check-in):**  
Annahme: Anwendung wird in kleinem Hotel mit wenigen gleichzeitigen Benutzern eingesetzt → Wahrscheinlichkeit NIEDRIG. Bei größerem Hotel oder Self-Service-Terminals: Wahrscheinlichkeit HOCH.

**R-GUEST-002 (Umlaute):**  
Annahme: Alle UTF-8-Zeichen sind erlaubt. Testbasis Frage 4 ist offen (Welche Zeichen sind in Gast-Namen erlaubt?).

**R-CHECKIN-003 (Check-out ohne Zimmerzuweisung):**  
Annahme: Manuelle DB-Manipulation kommt im Normalbetrieb nicht vor → Wahrscheinlichkeit NIEDRIG. Falls DB-Direktzugriff Teil des Workflows: Wahrscheinlichkeit HOCH.

**R-CHECKIN-004 (Zimmerwechsel):**  
Annahme: Zimmerwechsel erfordert expliziten Check-out + Check-in. Testbasis Frage 7 ist offen (Ist direkter Check-in ohne Check-out erlaubt?).

**R-MSG-004 (Gast sieht Nachrichten anderer Räume):**  
Annahme: Gäste kennen normalerweise nur ihre eigene Raum-ID → Wahrscheinlichkeit MITTEL. Falls Raum-IDs leicht erratbar (1, 2, 3, ...): Wahrscheinlichkeit HOCH.

**R-MSG-005 (Auto-Delivery):**  
Annahme: Auto-Delivery-Mechanismus ist fachlich korrekt. NA-001 in Akzeptanzkriterien dokumentiert offene fachliche Frage (Was bedeutet „delivered"?).

**R-SEC-001 (XSS):**  
Annahme: Kein explizites HTML-Escaping implementiert → Wahrscheinlichkeit MITTEL. Falls Framework automatisch escaped: Wahrscheinlichkeit NIEDRIG (Code-Review erforderlich).

**R-SEC-002 (SQL-Injection):**  
Annahme: SQLAlchemy ORM wird korrekt verwendet (parametrisierte Queries) → Wahrscheinlichkeit NIEDRIG. Falls Raw-SQL verwendet: Wahrscheinlichkeit HOCH (Code-Review erforderlich).

**R-SEC-003 (Sender-Impersonation):**  
Annahme: Sender-Impersonation ist ein Problem. Falls Freitext-Sender akzeptierte Design-Entscheidung (gemäß Decision 006), ist dies dokumentierte Limitation, nicht Bug.

**R-PERF-001 (Performance bei vielen Nachrichten):**  
Annahme: Anwendung wird als Trainingsprojekt mit kleiner Datenmenge betrieben → Priorität NIEDRIG. Bei Produktiv-Einsatz: Priorität HOCH.

---

**Ende der Risikoanalyse**
