# Robot Framework Suite — Hotel- und Chatfunktion

Automatisierte Umsetzung von `docs/testing/testfaelle.md` (TC-CHAT-001 bis
TC-CHAT-021). Der Anwendungscode wurde für diese Aufgabe nicht verändert.

## Struktur

```text
tests/robot/
├── resources/
│   ├── api.resource     # Domain-Keywords über RequestsLibrary (Rooms, Guests, Check-in/out, Messages)
│   └── ui.resource       # Domain-Keywords über Browser Library (Rezeptions- und Gastsicht)
├── api/                  # Testfälle auf API-Ebene
│   ├── rooms.robot        # TC-CHAT-001..003
│   ├── guests.robot        # TC-CHAT-004..008
│   ├── checkinout.robot     # TC-CHAT-009, TC-CHAT-010, TC-CHAT-018 (manuell)
│   └── messages.robot        # TC-CHAT-011..015, TC-CHAT-017 (manuell)
└── e2e/                   # Testfälle auf Browser-Ebene
    ├── guest_view.robot      # TC-CHAT-016
    └── security_xss.robot     # TC-CHAT-019..021
```

Jeder Testfall trägt seine Testfall-ID aus `testfaelle.md` als Tag
(`TC-CHAT-NNN`), zusätzlich die zugehörige Akzeptanzkriterien- und
Risiko-ID. Testdaten stellen die Tests über die API selbst her (Gäste
anlegen/löschen); Räume werden über `Ensure Room Status` in einen
definierten Zustand gebracht, da die Seed-Daten nur fünf feste Räume
enthalten und keine Endpunkte zum Anlegen/Löschen von Räumen existieren.

## Bewusst nicht automatisiert (🧪 manuell)

- **TC-CHAT-017** (Nachrichtenhistorie nach Neustart) — erfordert einen
  Neustart des Anwendungsprozesses.
- **TC-CHAT-018** (gleichzeitiger Check-in) — Nebenläufigkeitstest ohne
  bestätigtes erwartetes Ergebnis für den Konfliktfall.

Beide sind als Robot-Testfälle mit `Skip` und Begründung enthalten (Tag
`manual`), damit sie im Report als **SKIP**, nicht als fehlend, erscheinen
und ihre Testfall-ID nachvollziehbar bleibt.

## Voraussetzungen

- `.venv` mit `robotframework`, `robotframework-requests`,
  `robotframework-browser` (bereits installiert).
- Browser Library initialisiert (`rfbrowser init`) — bereits vorhanden.
- Eine laufende Anwendungsinstanz mit einer **separaten Test-Datenbank**,
  damit `data/hotel.db` nicht durch die Tests verändert wird:

  ```bash
  DATABASE_URL="sqlite:///./data/robot_run.db" \
    .venv/bin/python -m uvicorn app.main:app --host 127.0.0.1 --port 8001
  ```

  Läuft bereits eine andere Instanz auf Port 8000 (z. B. für manuelle
  Exploration), startet dieser Befehl bewusst eine zweite, unabhängige
  Instanz auf Port 8001 — die Tests laufen gegen `http://127.0.0.1:8001` per
  Default (`BASE_URL` / `UI_BASE_URL` in `resources/*.resource`).

## Ausführen

```bash
# Alle Tests
.venv/bin/python -m robot --outputdir results/robot-full tests/robot

# Nur API-Ebene
.venv/bin/python -m robot --outputdir results/robot-api tests/robot/api

# Nur E2E-Ebene
.venv/bin/python -m robot --outputdir results/robot-e2e tests/robot/e2e

# E2E sichtbar und verlangsamt (Demo/Debugging)
.venv/bin/python -m robot --outputdir results/robot-visible \
  --variable HEADLESS:False --variable SLOWMO:1s tests/robot/e2e

# Gegen eine andere Instanz/Datenbank
.venv/bin/python -m robot --variable BASE_URL:http://127.0.0.1:8000 \
  --variable UI_BASE_URL:http://127.0.0.1:8000 --outputdir results/robot-full tests/robot
```

`report.html` und `log.html` im jeweiligen `--outputdir` zeigen das Ergebnis
je Testfall.

## Erwartetes Ergebnis dieses Laufs

- **16 bestanden** — alle Testfälle für Raum-, Gäste-, Check-in-/out- und
  Messaging-Kernfunktionen sowie die Gastsicht-Zimmerisolierung.
- **2 übersprungen** — TC-CHAT-017 und TC-CHAT-018 (siehe oben).
- **3 fehlgeschlagen — TC-CHAT-019, TC-CHAT-020, TC-CHAT-021.** Das ist ein
  **erwarteter Nachweis eines realen Produktfehlers, kein Testfehler.**
  `docs/testing/analyse_20260804.md` (Abschnitt 5.1) und
  `docs/testing/risikoanalyse.md` (R-CHAT-017) dokumentieren bereits durch
  Code-Prüfung, dass `static/js/messages.js` und
  `static/js/guest_messages.js` Nachrichteninhalt und Sender-Wert
  ungeschützt über `element.innerHTML` einfügen. Die Testausgabe bestätigt
  das: `<b>Test</b>` erscheint in der gerenderten Zeile als fett
  dargestelltes „Test“ statt als literaler Text `<b>Test</b>`. Dieser
  Fehler wurde in dieser Aufgabe **nicht behoben** — der Anwendungscode
  bleibt unverändert.

  Das erwartete Ergebnis dieser drei Testfälle beruht auf einer Auslegung
  von AC-CHAT-014 / AC-CHAT-016 (siehe `testfaelle.md`, „Hinweis zur
  Ableitung“ bei TC-CHAT-019) und sollte vor Verbindlichkeit fachlich
  bestätigt werden.
