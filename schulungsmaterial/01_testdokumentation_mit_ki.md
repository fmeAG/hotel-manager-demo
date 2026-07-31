# Schulungsaufgabe 1: Testdokumentation mit KI erarbeiten

## Einordnung

Diese Aufgabe ist der erste praktische Teil der Testerschulung. Die
Teilnehmenden lernen zunächst die Hotel-Anwendung und ihre Chatfunktion kennen.
Anschließend nutzen sie Claude Code, um aus Anwendung, Spezifikation und
Projektdokumentation eine belastbare Testbasis zu entwickeln.

In dieser Aufgabe werden noch keine automatisierten Tests erstellt. Robot
Framework wird erst in einer späteren Aufgabe eingeführt.

## Ausgangssituation

Das Projekt enthält zu Beginn:

- eine lauffähige Hotel-Anwendung mit Chatfunktion,
- eine fachliche Spezifikation der Chatfunktion,
- eine Beschreibung der Anwendung und ihrer Schnittstellen,
- den Quellcode der Anwendung,
- die vorgegebene Struktur für Testdokumentation.

Das Projekt enthält zu Beginn noch nicht:

- ausgearbeitete Akzeptanzkriterien für die Schulungsaufgabe,
- eine dokumentierte Testbasis,
- eine Risikoanalyse,
- konkrete Testfälle,
- Robot-Framework-Tests,
- Hinweise auf eventuell vorbereitete Produktfehler.

## Lernziele

Nach der Aufgabe können die Teilnehmenden:

- eine unbekannte Anwendung aus Sicht eines Testers erkunden,
- Claude Code zur strukturierten Analyse eines Projekts einsetzen,
- belegte Informationen von Annahmen der KI unterscheiden,
- unklare oder widersprüchliche Anforderungen erkennen,
- prüfbare Akzeptanzkriterien formulieren,
- Produktrisiken und geeignete Testideen ableiten,
- aus Akzeptanzkriterien konkrete Testfälle erstellen,
- KI-generierte Testdokumentation fachlich prüfen und verbessern,
- Anforderungen, Risiken und Testfälle nachvollziehbar miteinander verbinden.

## Erwartetes Ergebnis

Am Ende der Aufgabe liegt im Projekt eine erste, fachlich geprüfte
Testdokumentation vor:

```text
docs/
└── testing/
    ├── testbasis.md
    ├── akzeptanzkriterien.md
    ├── risikoanalyse.md
    ├── testfaelle.md
    └── traceability.md
```

Die Dokumente bilden später die Grundlage für die Auswahl und Automatisierung
von Testfällen mit Robot Framework.

## Wichtige Arbeitsregel

Claude Code unterstützt die Analyse und erstellt Entwürfe. Die fachliche
Verantwortung bleibt bei den Testern.

Die KI darf:

- Informationen aus vorhandenen Quellen zusammenführen,
- Unklarheiten und Widersprüche aufzeigen,
- Akzeptanzkriterien vorschlagen,
- Risiken und Testideen vorschlagen,
- Testfälle als Entwurf formulieren,
- Dokumente nach Vorgabe anlegen und überarbeiten.

Die KI darf nicht:

- fehlende fachliche Entscheidungen als Tatsachen darstellen,
- unbelegte Anforderungen erfinden,
- den Anwendungscode verändern,
- vorbereitete Produktfehler beheben,
- ohne menschliches Review endgültig über erwartetes Verhalten entscheiden.

## Kennzeichnung von Ergebnissen

Wichtige Aussagen werden während der Analyse gekennzeichnet:

| Kennzeichnung | Bedeutung |
|---|---|
| `BELEGT` | Die Aussage lässt sich durch eine vorhandene Quelle nachweisen. |
| `ANNAHME` | Die Aussage wurde angenommen, ist aber nicht ausreichend belegt. |
| `OFFEN` | Für diese Frage fehlt eine fachliche Entscheidung. |
| `WIDERSPRUCH` | Zwei Quellen oder Quelle und Anwendung stimmen nicht überein. |

Eine Annahme der KI darf nicht unbemerkt zu einem Akzeptanzkriterium oder einem
erwarteten Testergebnis werden.

---

# Arbeitsauftrag für die Teilnehmenden

## Schritt 1: Anwendung starten und erkunden

Startet die Hotel-Anwendung entsprechend der bereitgestellten
Startanleitung. Öffnet die Anwendung im Browser und betrachtet insbesondere
die Chatfunktion.

Untersucht die Anwendung zunächst selbst:

- Welche Funktionen bietet der Chat?
- Wer kann Nachrichten senden und lesen?
- Wie wird ein Zielzimmer ausgewählt?
- Welche Informationen werden zu einer Nachricht angezeigt?
- Welche Statuswerte sind sichtbar?
- Welche Eingaben sind möglich?
- Welche Rückmeldungen zeigt die Anwendung?
- Was geschieht bei ungewöhnlichen oder ungültigen Eingaben?
- Welche fachlichen Fragen entstehen?

In diesem Schritt geht es noch nicht darum, möglichst viele Fehler zu finden.
Ziel ist ein gemeinsames Verständnis der Anwendung.

Haltet erste Beobachtungen und offene Fragen stichpunktartig fest.

## Schritt 2: Projekt mit Claude Code analysieren

Lasst Claude Code die vorhandenen Spezifikationen, die Projektdokumentation und
die relevanten Teile der Anwendung untersuchen.

Verwendet beispielsweise folgenden Auftrag:

  > Analysiere dieses Projekt aus Sicht eines Softwaretesters. Betrachte insbesondere die Hotel- und Chatfunktion.
  >
  > Untersuche die vorhandenen Spezifikationen, die Projektdokumentation sowie die relevanten Teile der Anwendung. Beschreibe:
  >
  > - die vorhandenen Funktionen,
  > - die verfügbaren fachlichen und technischen Quellen,
  > - offene fachliche Fragen,
  > - erkennbare Produktrisiken,
  > - mögliche Widersprüche zwischen Spezifikation, Dokumentation und Implementierung.
  >
  > Kennzeichne jede wichtige Aussage als BELEGT, ANNAHME, OFFEN oder WIDERSPRUCH. Nenne bei belegten Aussagen die konkrete Quelldatei und möglichst
  > den zugehörigen Abschnitt oder die relevante Codefundstelle.
  >
  > Erstelle noch keine Akzeptanzkriterien und keine Testfälle. Verändere weder Anwendungscode noch vorhandene Tests.
  >
  > Speichere ausschließlich das Analyseergebnis in:
  >
  > docs/testing/analyse_yyyymmdd.md
  >
  > Weitere Dateien dürfen nicht verändert werden. Zeige mir anschließend eine kurze Zusammenfassung der Analyse und die Liste aller veränderten
  > Dateien.

Prüft die Antwort gemeinsam:

- Hat Claude Code alle relevanten Quellen berücksichtigt?
- Sind die genannten Quellen tatsächlich vorhanden?
- Hat die KI Verhalten behauptet, das nirgends beschrieben ist?
- Stimmen die Aussagen mit euren Beobachtungen aus der Anwendung überein?
- Welche Fragen müssen durch einen Product Owner oder fachlichen
  Ansprechpartner beantwortet werden?

## Schritt 3: Testbasis dokumentieren

Erstellt mit Unterstützung von Claude Code die Datei
`docs/testing/testbasis.md`.

Sie soll mindestens enthalten:

1. Ziel der Testaktivitäten
2. betrachtete Quellen
3. Testgegenstand
4. Funktionen im Testumfang
5. Funktionen außerhalb des Testumfangs
6. bekannte Rahmenbedingungen
7. offene fachliche Fragen
8. dokumentierte Annahmen
9. gefundene Widersprüche

Möglicher Auftrag an Claude Code:

  > Erstelle auf Grundlage der geprüften Analyse in
  > docs/testing/analyse_yyyymmdd.md einen Entwurf für
  > docs/testing/testbasis.md.
  >
  > Berücksichtige zusätzlich die in der Analyse genannten Originalquellen. Übernimm Aussagen nicht ungeprüft allein deshalb, weil sie im
  > Analyseprotokoll stehen.
  >
  > Die Testbasis muss mindestens folgende Abschnitte enthalten:
  >
  > 1. Ziel der Testaktivitäten
  > 2. Testgegenstand
  > 3. betrachtete fachliche und technische Quellen
  > 4. Funktionen innerhalb des Testumfangs
  > 5. Funktionen außerhalb des Testumfangs
  > 6. bekannte Rahmenbedingungen und Einschränkungen
  > 7. belegte fachliche Anforderungen
  > 8. dokumentierte Annahmen
  > 9. offene fachliche Fragen
  > 10. gefundene Widersprüche
  > 11. erste bekannte Produktrisiken
  >
  > Beachte dabei folgende Regeln:
  >
  > - Verwende für bestätigte Aussagen ausschließlich belegte Informationen.
  > - Nenne bei belegten Aussagen die konkrete Quelle.
  > - Führe ANNAHME, OFFEN und WIDERSPRUCH in getrennten Abschnitten.
  > - Löse offene Fragen oder Widersprüche nicht eigenständig auf.
  > - Stelle Implementierungsverhalten nicht automatisch als fachliche Anforderung dar.
  > - Formuliere noch keine Akzeptanzkriterien und keine Testfälle.
  > - Verändere weder Anwendungscode noch vorhandene Tests.
  > - Verändere ausschließlich docs/testing/testbasis.md.
  >
  > Zeige anschließend:
  >
  > - eine kurze Zusammenfassung des Entwurfs,
  > - die wichtigsten weiterhin offenen Fragen,
  > - alle veränderten Dateien.

Prüft den erzeugten Entwurf und korrigiert ihn gemeinsam.

## Schritt 4: Akzeptanzkriterien formulieren

Leitet aus den bestätigten Anforderungen prüfbare Akzeptanzkriterien ab.

Jedes Akzeptanzkriterium erhält:

- eine eindeutige ID,
- einen verständlichen Titel,
- eine Quelle,
- eine Beschreibung im Format „Gegeben – Wenn – Dann“,
- gegebenenfalls einen Verweis auf eine noch offene Frage.

Beispiel:

```markdown
## AC-CHAT-001: Nachricht an ein belegtes Zimmer senden

Quelle:
- `specs/chat_feature_spec.md`

Gegeben, ein belegtes Zimmer existiert
und ein Gast ist diesem Zimmer zugeordnet,

wenn die Rezeption eine nicht leere Nachricht an das Zimmer sendet,

dann wird die Nachricht gespeichert
und mit dem Status `sent` angezeigt.
```

Möglicher Auftrag an Claude Code:

  > Erstelle auf Grundlage der fachlich geprüften
  > docs/testing/testbasis.md einen Entwurf für
  > docs/testing/akzeptanzkriterien.md.
  >
  > Leite Akzeptanzkriterien ausschließlich aus belegten und bestätigten fachlichen Anforderungen ab. Implementiertes Verhalten allein gilt nicht
  > automatisch als bestätigte Anforderung.
  >
  > Jedes Akzeptanzkriterium muss enthalten:
  >
  > - eine eindeutige ID im Format AC-CHAT-NNN,
  > - einen kurzen, eindeutigen Titel,
  > - die zugrunde liegende Anforderung,
  > - eine konkrete Quellenangabe,
  > - eine Formulierung als Gegeben – Wenn – Dann,
  > - gegebenenfalls relevante Vorbedingungen,
  > - einen Verweis auf zugehörige offene Fragen oder Widersprüche.
  >
  > Beachte folgende Qualitätsregeln:
  >
  > - Ein Akzeptanzkriterium beschreibt möglichst nur ein prüfbares Verhalten.
  > - Das erwartete Ergebnis muss eindeutig und beobachtbar sein.
  > - Formuliere fachlich und unabhängig von der technischen Umsetzung.
  > - Verwende keine unbestimmten Begriffe wie „korrekt“, „schnell“, „geeignet“ oder „benutzerfreundlich“, sofern diese nicht näher definiert sind.
  > - Ergänze keine Grenzwerte, Fehlermeldungen, Statuscodes oder Geschäftsregeln, die nicht belegt sind.
  > - Erstelle kein Akzeptanzkriterium, wenn das erwartete Verhalten noch offen oder widersprüchlich ist.
  > - Führe solche Fälle stattdessen in einem Abschnitt Nicht ableitbare Akzeptanzkriterien auf und verweise auf die entsprechende offene Frage oder
  >   den Widerspruch aus der Testbasis.
  >
  > - Formuliere noch keine konkreten Testfälle und nimm noch keine Risikobewertung vor.
  > - Verändere weder Anwendungscode noch vorhandene Tests.
  > - Verändere ausschließlich docs/testing/akzeptanzkriterien.md.
  >
  > Verwende für jedes Akzeptanzkriterium folgende Struktur:
  >
  > ## AC-CHAT-NNN: Titel
  >
  > **Anforderung:**
  > Kurze Beschreibung der zugrunde liegenden fachlichen Anforderung.
  >
  > **Quelle:**
  > - `Pfad zur Quelldatei`, Abschnitt
  >
  > **Gegeben** ...
  >
  > **Wenn** ...
  >
  > **Dann** ...
  >
  > **Offene Bezüge:**
  > - Keine
  >
  > Prüfe den Entwurf abschließend selbst auf:
  >
  > - eindeutige und beobachtbare Ergebnisse,
  > - korrekte Quellenangaben,
  > - unbelegte Annahmen,
  > - vermischte Verhaltensweisen,
  > - technische statt fachliche Formulierungen.
  >
  > Zeige anschließend eine kurze Zusammenfassung, die nicht ableitbaren Kriterien und alle veränderten Dateien.

Prüft für jedes Akzeptanzkriterium:

- Ist das erwartete Verhalten eindeutig?
- Kann das Ergebnis beobachtet werden?
- Ist das Kriterium unabhängig von einer bestimmten technischen Umsetzung?
- Ist die Quelle korrekt?
- Enthält das Kriterium eine unbelegte Annahme?
- Kann aus dem Kriterium mindestens ein konkreter Test abgeleitet werden?

## Schritt 5: Risiken und Testideen ableiten

Ermittelt mögliche Produktrisiken. Betrachtet dabei nicht nur technische
Fehler, sondern auch Auswirkungen auf Hotelmitarbeiter und Gäste.

Beispiele für Fragestellungen:

- Was wäre besonders problematisch, wenn es nicht funktioniert?
- Könnte eine Nachricht dem falschen Zimmer zugeordnet werden?
- Könnten vertrauliche Informationen für falsche Personen sichtbar sein?
- Könnten Nachrichten verloren gehen oder doppelt gespeichert werden?
- Könnte ein Nachrichtenstatus falsch angezeigt werden?
- Was geschieht bei leeren, langen oder ungewöhnlichen Nachrichten?
- Bleiben Nachrichten nach einem Neustart erhalten?

Dokumentiert die Ergebnisse in `docs/testing/risikoanalyse.md`.

Jedes Risiko erhält mindestens:

- eine eindeutige ID,
- eine Beschreibung,
- die mögliche Auswirkung,
- eine grobe Eintrittswahrscheinlichkeit,
- eine Priorität,
- betroffene Akzeptanzkriterien,
- erste Testideen.

Möglicher Auftrag an Claude Code:

> Erstelle auf Basis der bestätigten Akzeptanzkriterien einen Entwurf für
> `docs/testing/risikoanalyse.md`. Verwende IDs im Format `R-CHAT-NNN`.
> Beschreibe Auswirkung, Eintrittswahrscheinlichkeit und Priorität. Schlage
> positive Tests, negative Tests und relevante Grenzfälle vor. Begründe die
> Priorisierung. Weise ausdrücklich darauf hin, wenn eine Bewertung fachliche
> Annahmen enthält.

Die KI schlägt Risiken und Prioritäten vor. Die endgültige Bewertung erfolgt
durch die Teilnehmenden.

## Schritt 6: Konkrete Testfälle erstellen

Wählt die wichtigsten Akzeptanzkriterien und Risiken aus. Erstellt daraus
konkrete Testfälle in `docs/testing/testfaelle.md`.

Jeder Testfall enthält:

- eindeutige Testfall-ID,
- Titel und Testziel,
- zugehörige Akzeptanzkriterien,
- abgedeckte Risiken,
- Priorität,
- vorgesehene Testebene, zum Beispiel API oder Web-UI,
- Voraussetzungen,
- Testdaten,
- nachvollziehbare Schritte,
- konkrete erwartete Ergebnisse,
- Kennzeichnung, ob der Test ein Kandidat für Automatisierung ist.

Beispielstruktur:

```markdown
## TC-CHAT-001: Gültige Nachricht an ein Zimmer senden

### Bezug

- Akzeptanzkriterium: `AC-CHAT-001`
- Risiko: `R-CHAT-001`

### Einordnung

- Priorität: Hoch
- Testebene: API
- Automatisierungskandidat: Ja

### Voraussetzungen

- Zimmer 101 existiert.
- Ein Gast ist in Zimmer 101 eingecheckt.
- Die Anwendung befindet sich in einem definierten Ausgangszustand.

### Testdaten

- Zimmer: 101
- Nachricht: `Das Frühstück beginnt morgen um 07:00 Uhr.`

### Schritte

1. Eine Nachricht mit den angegebenen Testdaten an Zimmer 101 senden.
2. Die Nachrichten für Zimmer 101 abrufen.

### Erwartete Ergebnisse

1. Das Senden wird erfolgreich bestätigt.
2. Die Nachricht wird vollständig und unverändert gespeichert.
3. Die Nachricht ist Zimmer 101 zugeordnet.
4. Der initiale Nachrichtenstatus entspricht dem Akzeptanzkriterium.
```

Möglicher Auftrag an Claude Code:

> Erstelle für die priorisierten Akzeptanzkriterien und Risiken einen Entwurf
> für `docs/testing/testfaelle.md`. Verwende IDs im Format `TC-CHAT-NNN`.
> Beschreibe Voraussetzungen, konkrete Testdaten, Schritte und erwartete
> Ergebnisse. Ordne jeden Testfall einer geeigneten Testebene zu. Markiere
> geeignete Kandidaten für eine spätere Automatisierung mit Robot Framework.
> Erfinde kein erwartetes Verhalten, das nicht durch ein bestätigtes
> Akzeptanzkriterium gedeckt ist.

## Schritt 7: Nachverfolgbarkeit herstellen

Erstellt abschließend `docs/testing/traceability.md`.

Die Datei verbindet Akzeptanzkriterien, Risiken und Testfälle:

| Akzeptanzkriterium | Risiko | Testfall | Testebene | Automatisiert |
|---|---|---|---|---|
| `AC-CHAT-001` | `R-CHAT-001` | `TC-CHAT-001` | API | Nein |

Prüft anhand der Tabelle:

- Gibt es Akzeptanzkriterien ohne Testfall?
- Gibt es hoch priorisierte Risiken ohne Testfall?
- Gibt es Testfälle ohne Bezug zu einem Akzeptanzkriterium oder Risiko?
- Wurden unnötige oder doppelte Testfälle erzeugt?
- Welche Testfälle sind gute Kandidaten für die nächste Aufgabe?

---

# Gemeinsames Review

Die Aufgabe endet mit einem gemeinsamen Review der erstellten Dokumente.

## Reviewfragen

### Testbasis

- Sind Testumfang und Abgrenzung verständlich?
- Sind alle verwendeten Quellen genannt?
- Sind offene Fragen und Annahmen sichtbar?
- Wurden Widersprüche nachvollziehbar beschrieben?

### Akzeptanzkriterien

- Ist jedes Kriterium eindeutig und beobachtbar?
- Ist das erwartete Verhalten fachlich bestätigt?
- Sind Kriterien unnötig technisch formuliert?
- Hat Claude Code unbelegte Regeln ergänzt?

### Risikoanalyse

- Sind die wichtigsten fachlichen Risiken enthalten?
- Ist die Priorisierung nachvollziehbar?
- Wurden nur leicht automatisierbare Fälle betrachtet oder auch wichtige
  schwierige Risiken?

### Testfälle

- Hat jeder Testfall ein klares Ziel?
- Sind Voraussetzungen und Testdaten ausreichend beschrieben?
- Ist für jeden Schritt ein konkretes erwartetes Ergebnis vorhanden?
- Kann eine andere Person den Test ohne zusätzliche Erklärungen ausführen?
- Ist die ausgewählte Testebene sinnvoll?

### Nachverfolgbarkeit

- Sind Anforderungen, Risiken und Testfälle miteinander verbunden?
- Gibt es erkennbare Abdeckungslücken?
- Sind die wichtigsten Automatisierungskandidaten erkennbar?

## Definition of Done

Die Aufgabe ist abgeschlossen, wenn:

- alle fünf Testdokumente vorhanden sind,
- die Dokumente von den Teilnehmenden geprüft wurden,
- belegte Aussagen, Annahmen und offene Fragen unterscheidbar sind,
- alle priorisierten Testfälle auf bestätigte Akzeptanzkriterien verweisen,
- hoch priorisierte Risiken mindestens einem Testfall zugeordnet sind,
- mindestens ein geeigneter API-Testfall für die spätere
  Robot-Framework-Automatisierung ausgewählt wurde,
- Claude Code keine Anwendungsdateien verändert hat.

---

# Reflexion

Besprecht zum Abschluss:

1. Welche Ergebnisse der KI waren unmittelbar hilfreich?
2. Wo hat die KI Annahmen getroffen oder Anforderungen ergänzt?
3. Welche Fehler wären ohne menschliches Review in der Testdokumentation
   geblieben?
4. Hat die KI wichtige Risiken übersehen?
5. Welche Informationen musste der Mensch fachlich bewerten?
6. Wie hat die Dokumentationsstruktur die Arbeit unterstützt?
7. Welchen Testfall würdet ihr als Erstes automatisieren und warum?

## Zentrale Erkenntnis

Claude Code kann große Mengen an Projektinformationen analysieren, strukturieren
und erste Testartefakte erstellen. Die KI kann jedoch nicht selbst entscheiden,
welches fachliche Verhalten richtig ist. Tester bleiben verantwortlich für
Testziel, erwartetes Ergebnis, Risikobewertung und Freigabe der
Testdokumentation.

---

# Hinweise für die Schulungsleitung

## Vorbereitung

Vor der Schulung ist sicherzustellen:

- Die Hotel-Anwendung mit Chatfunktion ist lauffähig.
- Eine verständliche Startanleitung ist vorhanden.
- Spezifikation, API-Dokumentation und Anwendung sind grundsätzlich
  miteinander vergleichbar.
- `docs/documentation_structure.md` beschreibt die Ablage und Mindestinhalte
  der Testdokumentation.
- Das Verzeichnis `docs/testing/` ist entweder leer oder enthält nur
  unbefüllte Vorlagen.
- Vorhandene automatisierte Tests wurden aus dem Schulungsstand entfernt.
- Vorbereitete Produktfehler werden in keiner Teilnehmerunterlage verraten.
- Für fachlich offene Fragen stehen vorbereitete Trainerentscheidungen zur
  Verfügung.
- Ein unveränderter Ausgangsstand kann bei Bedarf schnell wiederhergestellt
  werden.

## Didaktische Hinweise

- Nicht sofort den vermeintlich besten Prompt vorgeben. Die Gruppe soll
  Unterschiede zwischen unpräzisen und kontrollierten Aufträgen erleben.
- Claude Code zunächst ausschließlich analysieren lassen.
- Dokumente nacheinander erstellen, nicht alle in einem einzigen großen Prompt.
- Nach jedem Dokument einen menschlichen Review durchführen.
- Bei erfundenen Anforderungen nicht nur korrigieren, sondern gemeinsam
  untersuchen, warum die Formulierung des Auftrags dies ermöglicht hat.
- Die Anzahl der Testfälle bewusst begrenzen. Qualität und Begründung sind
  wichtiger als eine große Menge generierter Tests.
- Noch keine Produktfehler auflösen. Die Fehler sollen später durch die
  automatisierten Tests sichtbar werden.

## Empfohlener Zeitrahmen

| Abschnitt | Richtwert |
|---|---:|
| Anwendung starten und gemeinsam erkunden | 10 Minuten |
| Projektanalyse und Testbasis | 15 Minuten |
| Akzeptanzkriterien | 15 Minuten |
| Risikoanalyse und Testideen | 15 Minuten |
| Testfälle und Nachverfolgbarkeit | 20 Minuten |
| Review und Reflexion | 15 Minuten |
| **Gesamt** | **90 Minuten** |

Falls für die gesamte Aufgabe weniger Zeit zur Verfügung steht, sollte der
Umfang auf wenige priorisierte Akzeptanzkriterien und drei bis fünf Testfälle
begrenzt werden. Die Review- und Reflexionsphase sollte nicht entfallen.

## Übergang zur nächsten Aufgabe

Die nächste Schulungsaufgabe (Schulungsaufgabe 2) überführt die fachlich
geprüfte Testdokumentation in ausführbare, automatisierte Tests mit Robot
Framework.

Der Arbeitsauftrag kann lauten:

> Lies die Testing-Dokumentation in `docs/testing/` und erstelle automatisierte
> Testfälle mit dem Robot Framework aus `docs/testing/testfaelle.md`. Verändere
> den Anwendungscode nicht.

Damit erleben die Teilnehmenden die vollständige Verbindung von der Anforderung
über die Testdokumentation bis zum ausführbaren automatisierten Test — und die
in Aufgabe 1 bewusst nicht aufgelösten, vorbereiteten Produktfehler werden
erstmals als fehlschlagende Tests sichtbar.

---

# Schulungsaufgabe 2: Testfälle mit Robot Framework automatisieren

## Einordnung

Diese Aufgabe ist der zweite praktische Teil der Testerschulung. Sie baut
unmittelbar auf der in Schulungsaufgabe 1 erstellten Testdokumentation auf. Die
Teilnehmenden lassen aus den dokumentierten Testfällen (`docs/testing/testfaelle.md`)
mit Claude Code eine ausführbare Robot-Framework-Testsuite erzeugen, führen sie
gegen die laufende Anwendung aus und interpretieren die Ergebnisse.

Der Anwendungscode wird in dieser Aufgabe noch **nicht** verändert. Ziel ist
zunächst, das dokumentierte Soll-Verhalten in automatisierte Prüfungen zu
überführen und den Ist-Zustand der Anwendung sichtbar zu machen — einschließlich
etwaiger Abweichungen.

## Ausgangssituation

Das Projekt enthält zu Beginn dieser Aufgabe:

- die fachlich geprüfte Testdokumentation aus Aufgabe 1
  (`testbasis.md`, `akzeptanzkriterien.md`, `risikoanalyse.md`, `testfaelle.md`),
- eine lauffähige Hotel-Anwendung mit REST-API und Browser-UI,
- eine installierte Testumgebung (Robot Framework, RequestsLibrary, Browser-Library).

Das Projekt enthält zu Beginn noch nicht:

- eine ausführbare Robot-Framework-Testsuite,
- eine Auswertung, welche dokumentierten Testfälle die Anwendung tatsächlich erfüllt,
- eine belastbare Aussage über die vorbereiteten Produktfehler.

## Lernziele

Nach der Aufgabe können die Teilnehmenden:

- dokumentierte Testfälle in ausführbare Robot-Framework-Tests überführen,
- Claude Code für die Erstellung einer wartbaren, mehrschichtigen Testsuite einsetzen,
- API-Tests (RequestsLibrary) und E2E-Tests (Browser-Library) unterscheiden und einordnen,
- die Rückverfolgbarkeit zwischen Testfall-ID und automatisiertem Test prüfen,
- Testergebnisse (bestanden / fehlgeschlagen / übersprungen) korrekt interpretieren,
- einen fehlgeschlagenen Test als Hinweis auf einen Produktfehler statt als Testfehler erkennen,
- beurteilen, welche Tests sinnvoll automatisierbar sind und welche manuell bleiben.

## Erwartetes Ergebnis

Am Ende der Aufgabe liegt im Projekt eine ausführbare, nach Ebenen getrennte
Testsuite vor:

```text
tests/
└── robot/
    ├── resources/          # wiederverwendbare Keywords (API, UI, Variablen)
    ├── api/                # Integrationstests auf API-Ebene
    ├── e2e/                # End-to-End-Tests über die Browser-UI
    └── README.md           # Ausführung, Voraussetzungen, Befunde
```

Ergänzend liegt ein dokumentierter Testlauf vor, der klar ausweist:

- welche Testfälle bestehen,
- welche fehlschlagen und welchen Produktfehler sie belegen,
- welche Testfälle bewusst als manuell/übersprungen gekennzeichnet sind.

## Wichtige Arbeitsregel

Claude Code erstellt die Testautomatisierung. Die fachliche Verantwortung für
Auswahl, erwartetes Ergebnis und Freigabe bleibt bei den Testern.

Die KI darf:

- aus `testfaelle.md` ausführbare Robot-Framework-Tests erstellen,
- wiederverwendbare Keywords und eine sinnvolle Projektstruktur anlegen,
- Testvorbedingungen über die API selbst herstellen und wieder aufräumen,
- Tests ausführen und die Ergebnisse zusammenfassen.

Die KI darf nicht:

- den Anwendungscode verändern,
- vorbereitete Produktfehler beheben,
- das erwartete Ergebnis eines Tests an fehlerhaftes Ist-Verhalten anpassen,
  nur damit der Test „grün“ wird — die Tests bilden das dokumentierte
  **Soll-Verhalten** ab,
- dokumentierte manuelle Tests unbemerkt als automatisiert ausgeben.

## Arbeitsauftrag für die Teilnehmenden

### Schritt 1: Testumgebung vorbereiten

Startet die Anwendung in einem definierten Ausgangszustand. Empfohlen wird eine
**separate Test-Datenbank**, damit die produktive `hotel.db` nicht verändert wird:

```bash
DATABASE_URL="sqlite:///./data/robot_run.db" \
  .venv/bin/python -m uvicorn app.main:app --host 127.0.0.1 --port 8000
```

Für die E2E-Tests müssen die Browser der Browser-Library einmalig initialisiert
sein (`.venv/bin/rfbrowser init`).

### Schritt 2: Testsuite von Claude Code erstellen lassen

Verwendet beispielsweise folgenden Auftrag:

  > Lies die Testing-Dokumentation in `docs/testing/` und erstelle automatisierte
  > Testfälle mit dem Robot Framework aus `docs/testing/testfaelle.md`. Verändere
  > den Anwendungscode nicht.

Achtet bewusst darauf, den Auftrag zunächst nur auf die **Automatisierungs­kandidaten**
(🤖) und die technisch automatisierbaren Sicherheitstests zu beziehen und die als
manuell markierten Fälle (🧪, z. B. Concurrency, Persistenz nach Neustart) als
solche zu kennzeichnen.

### Schritt 3: Aufbau der Suite prüfen

Prüft gemeinsam:

- Ist die Suite in **zwei Ebenen** getrennt (lesbare Testfälle vs. gekapselte
  Low-Level-Keywords in `resources/`)?
- Trägt jeder Test seine **Testfall-ID** (`TC-...`) als Tag, sodass die
  Rückverfolgbarkeit zu `testfaelle.md` erhalten bleibt?
- Stellen die Tests ihre Vorbedingungen selbst her und räumen sie wieder auf
  (die Seed-Daten enthalten nur Räume, keine Gäste/Nachrichten)?
- Wurden API- und E2E-Ebene passend zur Vorgabe aus `testfaelle.md` gewählt?
- Wurden die manuellen Fälle **nicht** stillschweigend „mitautomatisiert“?

### Schritt 4: Suite ausführen und Ergebnisse interpretieren

```bash
.venv/bin/python -m robot --outputdir results/robot-full tests/robot
```

Betrachtet `results/robot-full/report.html` und `log.html` und ordnet jedes
Ergebnis ein:

- **Bestanden:** Die Anwendung erfüllt das dokumentierte Soll-Verhalten.
- **Übersprungen:** bewusst manuell gehaltene Fälle (z. B. Concurrency, Neustart).
- **Fehlgeschlagen:** Hier weicht das Ist-Verhalten vom dokumentierten
  Soll-Verhalten ab. In diesem Projekt schlagen insbesondere die drei
  XSS-Tests (`TC-SEC-001..003`) fehl — sie weisen einen realen, vorbereiteten
  Produktfehler nach (Nachrichteninhalte werden ungeschützt gerendert).

Wichtig: Ein fehlgeschlagener Sicherheitstest ist an dieser Stelle **kein**
Testfehler, sondern der erwartete Nachweis eines Produktfehlers. Der Fehler wird
in dieser Aufgabe noch nicht behoben.

## Gemeinsames Review

### Reviewfragen

- Bildet jeder automatisierte Test seinen dokumentierten Testfall korrekt ab?
- Sind die erwarteten Ergebnisse aus dem Soll-Verhalten abgeleitet, nicht aus dem
  beobachteten Ist-Verhalten?
- Ist die Suite unabhängig von einer festen Ausführungsreihenfolge und
  wiederholbar?
- Sind die fehlschlagenden Tests nachvollziehbar einem Produktfehler zugeordnet?
- Sind manuelle Fälle klar als solche gekennzeichnet und begründet?

### Definition of Done

Die Aufgabe ist abgeschlossen, wenn:

- eine ausführbare Robot-Framework-Suite unter `tests/robot/` vorliegt,
- die automatisierten Tests auf die Testfall-IDs aus `testfaelle.md` zurückführbar sind,
- die Suite gegen die laufende Anwendung ausgeführt wurde,
- die Ergebnisse (bestanden / fehlgeschlagen / übersprungen) dokumentiert und
  interpretiert sind,
- die fehlschlagenden Tests einem konkreten Produktfehler zugeordnet sind,
- Claude Code **keine** Anwendungsdateien verändert hat.

## Reflexion

Besprecht zum Abschluss:

1. Welche Testfälle ließen sich unmittelbar automatisieren, welche nicht — und warum?
2. Wie hat die Trennung in Keyword-Ebene und Testfall-Ebene die Lesbarkeit beeinflusst?
3. Wodurch wurde der vorbereitete Produktfehler sichtbar, der bei der reinen
   Dokumentenprüfung (Aufgabe 1) verborgen blieb?
4. Woran erkennt man, dass ein fehlgeschlagener Test ein Produkt- und kein
   Testfehler ist?
5. Welche Risiken bestehen, wenn man Tests an das Ist-Verhalten anpasst, statt an
   das Soll-Verhalten?

## Hinweise für die Schulungsleitung

- Die vorbereiteten Produktfehler sollen genau hier als fehlschlagende Tests
  sichtbar werden. Nicht vorab verraten, wo sie liegen.
- Darauf bestehen, dass die erwarteten Ergebnisse aus `testfaelle.md` stammen.
  Falls die KI versucht, ein erwartetes Ergebnis dem beobachteten Ist-Verhalten
  anzugleichen, dies gemeinsam als Anti-Muster besprechen.
- Für die E2E-Tests im Vorfeld sicherstellen, dass die Browser der
  Browser-Library initialisiert sind.
- Immer gegen eine separate Test-Datenbank ausführen lassen, damit der
  Ausgangsstand schnell wiederherstellbar bleibt.

### Einführung in Robot Framework (Kurzpräsentation)

Zu Beginn dieser Aufgabe empfiehlt sich eine kurze Präsentation (wenige Folien,
ca. 10 Minuten), die Robot Framework einordnet, bevor die Teilnehmenden die
generierte Suite lesen. Vorschlag für die Folieninhalte:

1. **Was ist Robot Framework?** — ein generisches, offenes Automatisierungs-Framework
   für Test- und Robotic-Process-Automation, unabhängig von der Zielanwendung.
2. **Keyword-getriebener Ansatz** — Tests bestehen aus lesbaren „Keywords“;
   fachliche Testfälle und technische Umsetzung sind getrennt.
3. **Bibliotheken** — Funktionalität kommt aus Libraries, hier: RequestsLibrary
   (HTTP/REST) und Browser-Library (Playwright, UI/E2E).
4. **Aufbau einer Suite** — `.robot`-Dateien (`*** Settings ***`, `*** Test Cases ***`,
   `*** Keywords ***`) und wiederverwendbare `.resource`-Dateien.
5. **Zwei-Ebenen-Prinzip** — lesbare Testfälle oben, gekapselte Low-Level-Keywords
   in `resources/` — genau das Muster der gleich betrachteten Suite.
6. **Ergebnisberichte** — `report.html`, `log.html` und die Zustände
   bestanden / fehlgeschlagen / übersprungen.
7. **Einordnung im Kurs** — Brücke von der Testdokumentation (Aufgabe 1) zum
   ausführbaren Test.

Ziel ist ein gemeinsames Grundverständnis, keine vollständige Werkzeugschulung —
die Details erschließen sich anhand der konkreten Suite.

## Empfohlener Zeitrahmen

| Abschnitt | Richtwert |
|---|---:|
| Einführung in Robot Framework (Folien/Kurzpräsentation) | 10 Minuten |
| Testumgebung vorbereiten | 5 Minuten |
| Testsuite von Claude Code erstellen lassen | 15 Minuten |
| Aufbau der Suite prüfen | 15 Minuten |
| Suite ausführen und Ergebnisse interpretieren | 15 Minuten |
| Review und Reflexion | 15 Minuten |
| **Gesamt** | **75 Minuten** |

Steht weniger Zeit zur Verfügung, kann die Prüfung des Suite-Aufbaus gekürzt
werden; die Einführung, der Testlauf und die Ergebnisinterpretation sollten
erhalten bleiben.

## Übergang zur nächsten Aufgabe

Die fehlschlagenden Tests aus dieser Aufgabe bilden den Ausgangspunkt für
Schulungsaufgabe 3: Dort wird der nachgewiesene Produktfehler **testgetrieben**
behoben.

Der Arbeitsauftrag kann lauten:

> Bitte behebe die Fehler im Code auf Basis der fehlgeschlagenen Testfälle.

Damit erleben die Teilnehmenden den vollständigen Kreislauf: Anforderung →
Testdokumentation → automatisierter Test → aufgedeckter Fehler → behobener Fehler
mit automatisiertem Regressionsnachweis.

---

# Schulungsaufgabe 3: Produktfehler testgetrieben beheben

## Einordnung

Diese Aufgabe ist der dritte praktische Teil der Testerschulung. Sie schließt den
Kreis: Der in Schulungsaufgabe 2 durch fehlschlagende Tests nachgewiesene
Produktfehler wird jetzt behoben — **auf Basis der fehlschlagenden Testfälle** und
mit ihnen als Erfolgsnachweis.

Hier ändert sich die zentrale Arbeitsregel bewusst: Während in den Aufgaben 1 und
2 der Anwendungscode unangetastet blieb, ist die Codeänderung nun ausdrücklich
Ziel der Aufgabe. Die Teilnehmenden erleben den Perspektivwechsel von der
Fehler**erkennung** zur Fehler**behebung** und lernen, fehlgeschlagene Tests als
ausführbare Spezifikation zu nutzen.

## Ausgangssituation

Das Projekt enthält zu Beginn dieser Aufgabe:

- die ausführbare Robot-Framework-Suite aus Aufgabe 2,
- einen dokumentierten Testlauf mit fehlschlagenden Tests (`TC-SEC-001..003`),
- die zugehörige Testdokumentation und die Projekt-Entscheidungshistorie
  (`docs/decisions.md`, `docs/changelog.md`).

Das Projekt enthält zu Beginn noch nicht:

- die Fehlerbehebung im Anwendungscode,
- den Nachweis, dass die zuvor roten Tests nach der Behebung bestehen,
- die aktualisierte Projektdokumentation zur Behebung.

## Lernziele

Nach der Aufgabe können die Teilnehmenden:

- einen fehlgeschlagenen Test als präzise Vorgabe für eine Behebung lesen,
- Claude Code gezielt zur Ursachenanalyse und zu einer minimalen Behebung einsetzen,
- die vorgeschlagene Codeänderung fachlich und technisch bewerten,
- den Erfolg einer Behebung durch einen erneuten Testlauf belegen (Regressionsnachweis),
- erkennen, warum Tests nicht aufgeweicht werden dürfen, um sie „grün“ zu bekommen,
- Behebungen nachvollziehbar in Changelog und Entscheidungsdokumentation festhalten.

## Erwartetes Ergebnis

Am Ende der Aufgabe:

- ist der Produktfehler im Anwendungscode behoben,
- bestehen die zuvor fehlgeschlagenen Tests (`TC-SEC-001..003`),
- ist die übrige Suite unverändert grün (bewusste manuelle Skips ausgenommen),
- sind Changelog (Abschnitt „Fixed“) und Entscheidungsdokumentation
  (`docs/decisions.md`) entsprechend ergänzt.

## Wichtige Arbeitsregel

Claude Code führt die Behebung durch. Die Entscheidung, ob die Behebung fachlich
und technisch angemessen ist, bleibt bei den Teilnehmenden.

Die KI darf:

- die fehlgeschlagenen Tests als Vorgabe für die Behebung heranziehen,
- die Ursache im Anwendungscode analysieren und benennen,
- eine minimale, begründete Codeänderung vornehmen,
- die Behebung durch erneutes Ausführen der Tests belegen,
- Changelog und Entscheidungsdokumentation aktualisieren.

Die KI darf nicht:

- die Tests abschwächen, umschreiben oder deaktivieren, damit sie bestehen,
- über das durch die Tests belegte Soll-Verhalten hinaus „raten“ oder unnötig
  große Umbauten vornehmen,
- gespeicherte Nutzdaten stillschweigend verändern, um ein Symptom zu kaschieren,
- eine Behebung als abgeschlossen ausgeben, solange nicht alle betroffenen Tests
  nachweislich bestehen.

## Arbeitsauftrag für die Teilnehmenden

### Schritt 1: Fehlschläge verstehen

Öffnet den Testlauf aus Aufgabe 2 (`results/.../log.html`) und arbeitet heraus:

- Welche Testfälle schlagen fehl (`TC-SEC-001..003`)?
- Welches **Soll-Verhalten** fordern sie (Nachrichteninhalt wird als Text
  angezeigt, HTML wird nicht gerendert, Skripte/Event-Handler werden nicht
  ausgeführt)?
- Welches Ist-Verhalten zeigt die Anwendung stattdessen?

### Schritt 2: Behebung von Claude Code durchführen lassen

Verwendet beispielsweise folgenden Auftrag:

  > Bitte behebe die Fehler im Code auf Basis der fehlgeschlagenen Testfälle.

### Schritt 3: Ursachenanalyse prüfen

Prüft gemeinsam, ob die benannte Ursache belegt ist:

- Wo entsteht der Fehler (z. B. Rendering der Nachrichten in
  `static/js/messages.js` und `static/js/guest_messages.js`)?
- Warum führt er zur Ausführung von eingeschleustem HTML/JavaScript
  (Ausgabe über `innerHTML` statt textbasiert)?
- Sind sowohl Rezeptions- als auch Gastsicht betroffen?

### Schritt 4: Behebung bewerten

Prüft die vorgeschlagene Änderung auf Angemessenheit:

- Ist die Behebung **minimal** und auf die Ursache bezogen (Ausgabe als Text,
  z. B. über `textContent` / DOM-Aufbau, statt HTML-Interpolation)?
- Bleiben API, Datenmodell und gespeicherte Daten unverändert (Behebung als
  Ausgabe-, nicht als Eingabeproblem)?
- Wurden **keine** Tests abgeschwächt, um Grün zu erzeugen?

### Schritt 5: Regressionsnachweis führen

Führt die Suite erneut aus:

```bash
.venv/bin/python -m robot --outputdir results/robot-full tests/robot
```

Belegt, dass die zuvor roten Tests jetzt bestehen und keine zuvor grünen Tests
neu fehlschlagen. Die Sicherheitstests dienen nun als **Regressionsschutz**.

### Schritt 6: Dokumentation nachziehen

Haltet die Behebung nachvollziehbar fest:

- `docs/changelog.md`: Eintrag unter „Fixed“,
- `docs/decisions.md`: kurze Entscheidung zur gewählten Behebung inkl.
  verworfener Alternativen.

## Gemeinsames Review

### Reviewfragen

- Ist die Ursache belegt und nicht nur vermutet?
- Ist die Behebung minimal und auf das durch die Tests belegte Soll-Verhalten begrenzt?
- Wurden die Tests unverändert gelassen (kein Aufweichen)?
- Belegt ein erneuter Testlauf den Erfolg und die Abwesenheit neuer Fehlschläge?
- Ist die Behebung in Changelog und Entscheidungsdokumentation nachvollziehbar?

### Definition of Done

Die Aufgabe ist abgeschlossen, wenn:

- der Produktfehler im Anwendungscode behoben ist,
- die zuvor fehlgeschlagenen Tests nachweislich bestehen,
- keine zuvor bestehenden Tests neu fehlschlagen,
- die Tests inhaltlich unverändert geblieben sind,
- Changelog und Entscheidungsdokumentation aktualisiert wurden.

## Reflexion

Besprecht zum Abschluss:

1. Wie hat der fehlgeschlagene Test die Behebung angeleitet?
2. Woran erkennt man, dass eine Behebung die Ursache und nicht nur ein Symptom trifft?
3. Welche Gefahr entsteht, wenn Tests angepasst werden, um sie bestehen zu lassen?
4. Welchen Wert haben die Sicherheitstests nach der Behebung als Regressionsschutz?
5. Wie unterscheidet sich die Verantwortung des Menschen in Aufgabe 3 von der in
   den Aufgaben 1 und 2?

## Hinweise für die Schulungsleitung

- Der Rollen- und Regelwechsel (Codeänderung jetzt erlaubt) sollte explizit
  benannt werden.
- Besonders darauf achten, dass die Tests nicht verändert werden, um sie grün zu
  bekommen — dies ist der zentrale didaktische Punkt der Aufgabe.
- Auf einen echten, erneuten Testlauf als Nachweis bestehen; ein bloßes „müsste
  jetzt funktionieren“ genügt nicht.
- Die Pflege von Changelog und Entscheidungsdokumentation als festen Bestandteil
  der Behebung einfordern.

## Empfohlener Zeitrahmen

| Abschnitt | Richtwert |
|---|---:|
| Fehlschläge verstehen (Soll vs. Ist) | 10 Minuten |
| Behebung durch Claude Code durchführen lassen | 10 Minuten |
| Ursachenanalyse und Behebung bewerten | 15 Minuten |
| Regressionsnachweis (erneuter Testlauf) | 10 Minuten |
| Dokumentation nachziehen | 5 Minuten |
| Review und Reflexion | 10 Minuten |
| **Gesamt** | **60 Minuten** |

Steht weniger Zeit zur Verfügung, kann die Dokumentationspflege verkürzt werden;
der Regressionsnachweis darf nicht entfallen.

## Übergang zur nächsten Aufgabe

Mit einer belegten Behebung und grüner Suite ist der Kreislauf aus Anforderung,
Testdokumentation, Automatisierung und Fehlerbehebung vollständig durchlaufen.

Mögliche Anschlussthemen für weitere Aufgaben:

> Bindet die Robot-Framework-Suite in eine CI-Pipeline ein, sodass die Tests bei
> jeder Änderung automatisch ausgeführt werden.

> Weitet die Automatisierung auf weitere, bislang manuelle Testfälle aus und
> begründet, welche Fälle bewusst manuell bleiben.

Damit verschiebt sich der Fokus von der einmaligen Erstellung hin zur
dauerhaften, automatisierten Absicherung der Anwendung.
