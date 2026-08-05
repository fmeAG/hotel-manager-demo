# Testfälle: Hotel- und Chatfunktion

**Erstellt am:** 2026-08-04
**Grundlage:** `docs/testing/akzeptanzkriterien.md` (AC-CHAT-001 bis AC-CHAT-017), `docs/testing/risikoanalyse.md` (R-CHAT-001 bis R-CHAT-021)

## Legende

- 🤖 Automatisierungskandidat (spätere Umsetzung mit Robot Framework)
- 🧪 Bewusst manuell/nicht als Standard-Automatisierung vorgesehen (z. B. Nebenläufigkeit, Neustart der Anwendung)
- Testebene **API**: Prüfung über die REST-Schnittstelle (`RequestsLibrary`)
- Testebene **E2E**: Prüfung über die Browser-Oberfläche (`Browser`/`SeleniumLibrary`)

Erwartete Ergebnisse in diesem Dokument beschreiben ausschließlich Verhalten,
das durch ein bestätigtes Akzeptanzkriterium gedeckt ist. Wo ein Testfall zur
Herstellung einer Vorbedingung eine implementierte, aber nicht durch ein
Akzeptanzkriterium bestätigte Funktion nutzt (z. B. den bestehenden
Mechanismus zum Ändern des Nachrichtenstatus), ist dies unter
„Voraussetzungen" ausdrücklich vermerkt und fließt **nicht** in die
„Erwartete Ergebnisse" als Prüfaussage ein.

---

## TC-CHAT-001: Alle Räume auflisten

### Bezug

- Akzeptanzkriterium: `AC-CHAT-001`
- Risiko: `R-CHAT-001`

### Einordnung

- Priorität: Mittel
- Testebene: API
- Automatisierungskandidat: Ja 🤖

### Voraussetzungen

- Mindestens zwei Räume mit unterschiedlicher Raumnummer sind im System vorhanden (z. B. über Seed-Daten: 101, 102, 201, 202, 301).
- Die Anwendung befindet sich in einem definierten Ausgangszustand.

### Testdaten

- Keine zusätzlichen Eingabedaten (Leseoperation).

### Schritte

1. Die Liste aller Räume abrufen.

### Erwartete Ergebnisse

1. Alle im System vorhandenen Räume werden in der Liste zurückgegeben.

---

## TC-CHAT-002: Details eines einzelnen Raums ansehen

### Bezug

- Akzeptanzkriterium: `AC-CHAT-002`
- Risiko: `R-CHAT-001`

### Einordnung

- Priorität: Mittel
- Testebene: API
- Automatisierungskandidat: Ja 🤖

### Voraussetzungen

- Raum 101 mit Kategorie „Single" und Status „available" existiert.

### Testdaten

- Raum: 101

### Schritte

1. Die Details des Raums 101 abrufen.

### Erwartete Ergebnisse

1. Raumnummer (101), Kategorie (Single) und Belegungsstatus (available) werden angezeigt.

---

## TC-CHAT-003: Raumstatus ändern

### Bezug

- Akzeptanzkriterium: `AC-CHAT-003`
- Risiko: `R-CHAT-002`

### Einordnung

- Priorität: Mittel
- Testebene: API
- Automatisierungskandidat: Ja 🤖

### Voraussetzungen

- Raum 202 mit Status „cleaning" existiert (laut Seed-Daten).

### Testdaten

- Raum: 202
- Neuer Status: `available`

### Schritte

1. Den Status von Raum 202 auf `available` ändern.
2. Die Details von Raum 202 erneut abrufen.

### Erwartete Ergebnisse

1. Der neue Status (`available`) wird beim erneuten Abruf des Raums angezeigt.

---

## TC-CHAT-004: Gast anlegen

### Bezug

- Akzeptanzkriterium: `AC-CHAT-004`
- Risiko: `R-CHAT-005`

### Einordnung

- Priorität: Mittel
- Testebene: API
- Automatisierungskandidat: Ja 🤖

### Voraussetzungen

- Die Anwendung befindet sich in einem definierten Ausgangszustand.

### Testdaten

- Vorname: `Jörg`
- Nachname: `Müller`

### Schritte

1. Einen neuen Gast mit den angegebenen Testdaten anlegen.
2. Den angelegten Gast abrufen.

### Erwartete Ergebnisse

1. Das Anlegen wird bestätigt.
2. Der Gast ist mit Vorname `Jörg` und Nachname `Müller` abrufbar.

---

## TC-CHAT-005: Gästeliste abrufen

### Bezug

- Akzeptanzkriterium: `AC-CHAT-005`
- Risiko: `R-CHAT-004`

### Einordnung

- Priorität: Mittel
- Testebene: API
- Automatisierungskandidat: Ja 🤖

### Voraussetzungen

- Mindestens ein Gast ist im System vorhanden.

### Testdaten

- Keine zusätzlichen Eingabedaten (Leseoperation).

### Schritte

1. Die Liste aller Gäste abrufen.

### Erwartete Ergebnisse

1. Alle im System vorhandenen Gäste werden in der Liste zurückgegeben.

---

## TC-CHAT-006: Details eines einzelnen Gastes ansehen

### Bezug

- Akzeptanzkriterium: `AC-CHAT-006`
- Risiko: `R-CHAT-004`

### Einordnung

- Priorität: Mittel
- Testebene: API
- Automatisierungskandidat: Ja 🤖

### Voraussetzungen

- Ein Gast mit Vorname `Anna`, Nachname `Schmidt`, ohne zugewiesenen Raum, existiert.

### Testdaten

- Gast: `Anna Schmidt`

### Schritte

1. Die Details dieses Gastes abrufen.

### Erwartete Ergebnisse

1. Vorname (`Anna`), Nachname (`Schmidt`), zugewiesener Raum, Check-in-Datum und Check-out-Datum des Gastes werden angezeigt.

---

## TC-CHAT-007: Gast bearbeiten

### Bezug

- Akzeptanzkriterium: `AC-CHAT-007`
- Risiko: `R-CHAT-006`

### Einordnung

- Priorität: Mittel
- Testebene: API
- Automatisierungskandidat: Ja 🤖

### Voraussetzungen

- Ein Gast mit Vorname `Anna`, Nachname `Schmidt`, existiert.

### Testdaten

- Neuer Vorname: `Anna`
- Neuer Nachname: `Schmidt-Weber`

### Schritte

1. Den Nachnamen dieses Gastes auf `Schmidt-Weber` ändern.
2. Den Gast erneut abrufen.

### Erwartete Ergebnisse

1. Der geänderte Nachname (`Schmidt-Weber`) wird beim erneuten Abruf angezeigt.

---

## TC-CHAT-008: Gast löschen

### Bezug

- Akzeptanzkriterium: `AC-CHAT-008`
- Risiko: `R-CHAT-007`

### Einordnung

- Priorität: Mittel
- Testebene: API
- Automatisierungskandidat: Ja 🤖

### Voraussetzungen

- Ein Gast ohne zugewiesenen Raum existiert.

### Testdaten

- Gast: neu angelegter Testgast ohne Raumzuweisung

### Schritte

1. Diesen Gast löschen.
2. Versuchen, den gelöschten Gast abzurufen.

### Erwartete Ergebnisse

1. Das Löschen wird bestätigt.
2. Der Gast ist danach nicht mehr abrufbar.

---

## TC-CHAT-009: Gast einchecken

### Bezug

- Akzeptanzkriterium: `AC-CHAT-009`
- Risiko: `R-CHAT-008`

### Einordnung

- Priorität: Hoch
- Testebene: API
- Automatisierungskandidat: Ja 🤖

### Voraussetzungen

- Ein Gast ohne aktuell zugewiesenen Raum existiert.
- Raum 101 mit Status `available` existiert.

### Testdaten

- Gast: Testgast ohne Raum
- Raum: 101

### Schritte

1. Diesem Gast im Rahmen eines Check-ins Raum 101 zuweisen.
2. Den Gast erneut abrufen.
3. Raum 101 erneut abrufen.

### Erwartete Ergebnisse

1. Der Gast ist danach Raum 101 zugewiesen.
2. Raum 101 wird als belegt (`occupied`) geführt.
3. Beim Gast ist ein Check-in-Datum gespeichert.

---

## TC-CHAT-010: Gast auschecken

### Bezug

- Akzeptanzkriterium: `AC-CHAT-010`
- Risiko: `R-CHAT-010`

### Einordnung

- Priorität: Hoch
- Testebene: API
- Automatisierungskandidat: Ja 🤖

### Voraussetzungen

- Ein Gast mit zugewiesenem Raum (z. B. Raum 101, Status `occupied`) existiert.

### Testdaten

- Gast: eingecheckter Testgast
- Raum: 101

### Schritte

1. Diesen Gast auschecken.
2. Den Gast erneut abrufen.
3. Raum 101 erneut abrufen.

### Erwartete Ergebnisse

1. Die Raumzuweisung des Gastes ist danach entfernt.
2. Raum 101 wird unmittelbar danach als in Reinigung befindlich (`cleaning`) geführt, **nicht** als verfügbar (`available`).
3. Beim Gast ist ein Check-out-Datum gespeichert.

---

## TC-CHAT-011: Gültige Nachricht an ein Zimmer senden (korrekte Zimmerzuordnung)

### Bezug

- Akzeptanzkriterium: `AC-CHAT-011`
- Risiko: `R-CHAT-011`

### Einordnung

- Priorität: Hoch
- Testebene: API
- Automatisierungskandidat: Ja 🤖

### Voraussetzungen

- Raum 101 und Raum 201 existieren.
- Die Anwendung befindet sich in einem definierten Ausgangszustand (keine Vorbedingung bezüglich Gastzuweisung erforderlich, siehe `akzeptanzkriterien.md` AC-CHAT-011).

### Testdaten

- Zielraum: 101
- Sender: `Reception`
- Nachricht: `Das Frühstück beginnt morgen um 07:00 Uhr.`
- (Zur Abgrenzung) zweiter Raum: 201, Nachricht: `Ihr Zimmer wird um 14 Uhr gereinigt.`

### Schritte

1. Eine Nachricht mit den angegebenen Testdaten an Raum 101 senden.
2. Eine zweite Nachricht mit den angegebenen Testdaten an Raum 201 senden.
3. Die Nachrichten für Raum 101 abrufen.
4. Die Nachrichten für Raum 201 abrufen.

### Erwartete Ergebnisse

1. Das Senden beider Nachrichten wird jeweils bestätigt.
2. Jede Nachricht wird vollständig und unverändert mit eindeutiger ID, Sender, Inhalt, Erstellungszeitstempel und Status `sent` gespeichert.
3. Die für Raum 101 abgerufenen Nachrichten enthalten die an Raum 101 gesendete Nachricht.
4. Die für Raum 201 abgerufenen Nachrichten enthalten die an Raum 201 gesendete Nachricht, **nicht** die an Raum 101 gesendete Nachricht.

---

## TC-CHAT-012: Alle Nachrichten auflisten

### Bezug

- Akzeptanzkriterium: `AC-CHAT-012`
- Risiko: `R-CHAT-013`

### Einordnung

- Priorität: Mittel
- Testebene: API
- Automatisierungskandidat: Ja 🤖

### Voraussetzungen

- Mindestens eine Nachricht ist im System vorhanden.

### Testdaten

- Keine zusätzlichen Eingabedaten (Leseoperation).

### Schritte

1. Die Liste aller Nachrichten abrufen.

### Erwartete Ergebnisse

1. Alle im System vorhandenen Nachrichten werden in der Liste zurückgegeben.

---

## TC-CHAT-013: Nachrichten nach Raum filtern

### Bezug

- Akzeptanzkriterium: `AC-CHAT-013`
- Risiko: `R-CHAT-014`

### Einordnung

- Priorität: Mittel
- Testebene: API
- Automatisierungskandidat: Ja 🤖

### Voraussetzungen

- Raum 102 und Raum 202 existieren.

### Testdaten

- Nachricht A an Raum 102: `Ihr Taxi wartet in 10 Minuten.`
- Nachricht B an Raum 202: `Der Zimmerservice ist heute bis 22 Uhr erreichbar.`

### Schritte

1. Nachricht A an Raum 102 senden.
2. Nachricht B an Raum 202 senden.
3. Die Nachrichtenliste nach Raum 102 filtern.

### Erwartete Ergebnisse

1. Die gefilterte Liste enthält Nachricht A.
2. Die gefilterte Liste enthält **nicht** Nachricht B.

---

## TC-CHAT-014: Details einer einzelnen Nachricht ansehen

### Bezug

- Akzeptanzkriterium: `AC-CHAT-014`
- Risiko: `R-CHAT-012`

### Einordnung

- Priorität: Mittel
- Testebene: API
- Automatisierungskandidat: Ja 🤖

### Voraussetzungen

- Raum 301 existiert.

### Testdaten

- Zielraum: 301
- Sender: `Reception`
- Nachricht: `Herzlich willkommen im Hotel!`

### Schritte

1. Eine Nachricht mit den angegebenen Testdaten senden.
2. Die Details dieser Nachricht abrufen.

### Erwartete Ergebnisse

1. Eindeutige ID, Sender (`Reception`), Zielraum (301), Inhalt (`Herzlich willkommen im Hotel!`), Erstellungszeitstempel und aktueller Status der Nachricht werden angezeigt.

---

## TC-CHAT-015: Sichtbarkeit des Nachrichtenstatus

### Bezug

- Akzeptanzkriterium: `AC-CHAT-015`
- Risiko: `R-CHAT-015`

### Einordnung

- Priorität: Hoch
- Testebene: API
- Automatisierungskandidat: Ja 🤖

### Voraussetzungen

- Raum 101 existiert.
- Hinweis: Schritt 3 nutzt die vorhandene Funktion zum Ändern des
  Nachrichtenstatus als reine Vorbedingungs-Herstellung. Die Regeln dieser
  Statusänderung selbst sind **nicht** Gegenstand dieses Testfalls (siehe
  `akzeptanzkriterien.md`, „Nicht ableitbare Akzeptanzkriterien", Punkt 1).

### Testdaten

- Zielraum: 101
- Nachricht: `Ihr Anschlussflug wurde bestätigt.`

### Schritte

1. Eine Nachricht mit den angegebenen Testdaten senden.
2. Den Status dieser Nachricht abrufen.
3. Den Status dieser Nachricht mittels der vorhandenen Statusänderungsfunktion einmal weiterschalten.
4. Den Status dieser Nachricht erneut abrufen.

### Erwartete Ergebnisse

1. Nach dem Senden wird der Status `sent` angezeigt.
2. Nach der Statusänderung wird der geänderte, aktuelle Status der Nachricht angezeigt.

---

## TC-CHAT-016: Nachrichten des eigenen Raums ansehen (Gast)

### Bezug

- Akzeptanzkriterium: `AC-CHAT-016`
- Risiko: `R-CHAT-011`

### Einordnung

- Priorität: Hoch
- Testebene: E2E
- Automatisierungskandidat: Ja 🤖

### Voraussetzungen

- Raum 101 und Raum 201 existieren.
- Für Raum 101 existiert eine Nachricht `Ihr Zimmer ist bereit.`
- Für Raum 201 existiert eine Nachricht `Bitte melden Sie sich an der Rezeption.`

### Testdaten

- Aufzurufender Raum (Gastsicht): 101

### Schritte

1. Die Gastsicht für Raum 101 öffnen.
2. Die angezeigten Nachrichten prüfen.

### Erwartete Ergebnisse

1. Die Nachricht `Ihr Zimmer ist bereit.` (Raum 101) wird angezeigt.
2. Die Nachricht `Bitte melden Sie sich an der Rezeption.` (Raum 201) wird **nicht** angezeigt.

---

## TC-CHAT-017: Nachrichtenhistorie bleibt nach Neustart der Anwendung erhalten 🧪

### Bezug

- Akzeptanzkriterium: `AC-CHAT-017`
- Risiko: `R-CHAT-019`

### Einordnung

- Priorität: Hoch
- Testebene: API
- Automatisierungskandidat: Nein 🧪 (erfordert Neustart des Anwendungsprozesses; nicht Teil eines normalen automatisierten Testlaufs)

### Voraussetzungen

- Die Anwendung läuft mit einer dateibasierten Datenbank (nicht In-Memory).

### Testdaten

- Zielraum: 102
- Nachricht: `Diese Nachricht muss einen Neustart überstehen.`

### Schritte

1. Eine Nachricht mit den angegebenen Testdaten senden.
2. Die Anwendung vollständig neu starten.
3. Die Nachrichten für Raum 102 nach dem Neustart abrufen.

### Erwartete Ergebnisse

1. Die Nachricht ist nach dem Neustart weiterhin unverändert vorhanden und abrufbar.

---

## TC-CHAT-018: Gleichzeitiger Check-in mehrerer Gäste auf denselben Raum 🧪

### Bezug

- Akzeptanzkriterium: `AC-CHAT-009`
- Risiko: `R-CHAT-009`

### Einordnung

- Priorität: Mittel
- Testebene: API
- Automatisierungskandidat: Nein 🧪 (Nebenläufigkeitstest, nicht Teil der Standard-Automatisierung; Ergebnis ist zudem nicht durch ein bestätigtes Akzeptanzkriterium für den Konfliktfall abgedeckt)

### Voraussetzungen

- Zwei Gäste ohne zugewiesenen Raum existieren.
- Raum 201 mit Status `available` existiert.

### Testdaten

- Gast A, Gast B
- Raum: 201

### Schritte

1. Nahezu zeitgleich einen Check-in von Gast A und Gast B auf Raum 201 auslösen.
2. Den Zustand von Raum 201 und beider Gäste danach beobachten.

### Erwartete Ergebnisse

- Kein bestätigtes erwartetes Ergebnis vorhanden (siehe `risikoanalyse.md`, R-CHAT-009). Dieser Testfall dient der **Beobachtung und Dokumentation** des tatsächlichen Verhaltens, nicht der Prüfung gegen ein bestätigtes Kriterium.

---

## TC-CHAT-019: Nachrichteninhalt wird beim Anzeigen nicht als aktiver Code ausgeführt (Rezeptionssicht)

### Bezug

- Akzeptanzkriterium: `AC-CHAT-014`
- Risiko: `R-CHAT-017`

### Einordnung

- Priorität: Hoch
- Testebene: E2E
- Automatisierungskandidat: Ja 🤖

**Hinweis zur Ableitung:** AC-CHAT-014 bestätigt, dass der Nachrichteninhalt
beim Anzeigen angezeigt wird, spezifiziert aber nicht wörtlich, dass er als
reiner Text (statt als aktives Markup) angezeigt werden muss. Das erwartete
Ergebnis dieses Testfalls beruht auf der Auslegung, dass „Inhalt wird
angezeigt" die Anzeige der eingegebenen Zeichenkette bedeutet, nicht deren
Interpretation als ausführbarer Code. Diese Auslegung ist vor Verwendung als
verbindliches Soll-Verhalten fachlich zu bestätigen.

### Voraussetzungen

- Raum 101 existiert.

### Testdaten

- Zielraum: 101
- Nachrichteninhalt: `<b>Test</b>` (einfaches HTML-Markup zur Beobachtung, ob es als Formatierung interpretiert wird)

### Schritte

1. Eine Nachricht mit dem angegebenen Inhalt an Raum 101 senden.
2. Die Nachrichtenliste in der Rezeptionsansicht öffnen.
3. Die Darstellung der Nachricht prüfen.

### Erwartete Ergebnisse

1. Der Nachrichteninhalt wird als Text `<b>Test</b>` angezeigt, nicht als fett formatierter Text „Test".

---

## TC-CHAT-020: Sender-Feld wird beim Anzeigen nicht als aktiver Code ausgeführt (Rezeptionssicht)

### Bezug

- Akzeptanzkriterium: `AC-CHAT-014`
- Risiko: `R-CHAT-017`

### Einordnung

- Priorität: Hoch
- Testebene: E2E
- Automatisierungskandidat: Ja 🤖

**Hinweis zur Ableitung:** Wie TC-CHAT-019, angewendet auf das Sender-Feld,
das laut AC-CHAT-011/AC-CHAT-014 ebenfalls angezeigt wird.

### Voraussetzungen

- Raum 102 existiert.

### Testdaten

- Zielraum: 102
- Sender: `<b>Reception</b>`
- Nachricht: `Testnachricht`

### Schritte

1. Eine Nachricht mit dem angegebenen Sender-Wert an Raum 102 senden.
2. Die Nachrichtenliste in der Rezeptionsansicht öffnen.
3. Die Darstellung des Sender-Felds prüfen.

### Erwartete Ergebnisse

1. Der Sender-Wert wird als Text `<b>Reception</b>` angezeigt, nicht als fett formatierter Text „Reception".

---

## TC-CHAT-021: Nachrichteninhalt wird beim Anzeigen nicht als aktiver Code ausgeführt (Gastsicht)

### Bezug

- Akzeptanzkriterium: `AC-CHAT-016`
- Risiko: `R-CHAT-017`

### Einordnung

- Priorität: Hoch
- Testebene: E2E
- Automatisierungskandidat: Ja 🤖

**Hinweis zur Ableitung:** Wie TC-CHAT-019, angewendet auf die Gastsicht
(AC-CHAT-016 bestätigt, dass dem Raum zugeordnete Nachrichten dem Gast
angezeigt werden).

### Voraussetzungen

- Raum 201 existiert.

### Testdaten

- Zielraum: 201
- Nachrichteninhalt: `<b>Test</b>`

### Schritte

1. Eine Nachricht mit dem angegebenen Inhalt an Raum 201 senden.
2. Die Gastsicht für Raum 201 öffnen.
3. Die Darstellung der Nachricht prüfen.

### Erwartete Ergebnisse

1. Der Nachrichteninhalt wird als Text `<b>Test</b>` angezeigt, nicht als fett formatierter Text „Test".

---

## Nicht ableitbare Testfälle

Die folgenden aus der Risikoanalyse naheliegenden Testideen wurden **nicht**
als Testfall mit geprüftem erwarteten Ergebnis aufgenommen, da kein
bestätigtes Akzeptanzkriterium ein erwartetes Verhalten für sie festlegt.

- **Ungültiger Raumstatus** (`R-CHAT-003`): Kein Akzeptanzkriterium legt
  fest, was bei einem nicht spezifizierten Statuswert geschehen soll.
- **Leere oder extrem lange Nachrichten/Namen** (`R-CHAT-016`, verwandt zu
  `R-CHAT-005`): Zulässige Länge/Format sind laut `testbasis.md` Abschnitt 9
  offen.
- **Nachricht an einen nicht existierenden Raum**: In
  `akzeptanzkriterien.md` nicht durch ein Kriterium gedeckt (Verhalten bei
  ungültigem Zielraum ist nicht Teil der bestätigten Anforderungen).
- **Fehler-Feedback im Frontend bei fehlgeschlagenen Aktionen**
  (`R-CHAT-021`): Kein Akzeptanzkriterium beschreibt ein erwartetes
  Rückmeldungsverhalten bei Fehlern.
- **Zugriff auf Nachrichten eines fremden Raums über eine bekannte Raum-ID**
  (`R-CHAT-018`): Laut `testbasis.md`/`risikoanalyse.md` eine dokumentierte
  Scope-Grenze (kein Auth), kein Produktfehler — daher kein Testfall mit
  Pass/Fail-Erwartung, sondern bereits in der Risikoanalyse als bekannte
  Rahmenbedingung dokumentiert.
- **Wer/wann den Status auf „delivered"/„read" setzt** (`R-CHAT-020`
  betrifft dies indirekt): Der Übergangsmechanismus selbst ist laut
  `akzeptanzkriterien.md`, „Nicht ableitbare Akzeptanzkriterien", Punkt 1,
  nicht bestätigt und daher nicht eigenständig test- bzw. bewertbar
  (lediglich als Vorbedingungs-Hilfsmittel in TC-CHAT-015 verwendet).

---

## Übersicht nach Priorität

**Hoch:** TC-CHAT-009, TC-CHAT-010, TC-CHAT-011, TC-CHAT-015, TC-CHAT-016, TC-CHAT-017, TC-CHAT-019, TC-CHAT-020, TC-CHAT-021

**Mittel:** TC-CHAT-001 bis TC-CHAT-008, TC-CHAT-012, TC-CHAT-013, TC-CHAT-014, TC-CHAT-018

**Automatisierungskandidaten (🤖):** alle außer TC-CHAT-017 und TC-CHAT-018 (🧪, manuell)

---

**Ende der Testfälle**
