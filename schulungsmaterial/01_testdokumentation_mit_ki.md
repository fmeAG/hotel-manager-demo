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

Die nächste Schulungsaufgabe beginnt mit der Auswahl eines priorisierten
API-Testfalls aus `testfaelle.md`.

Der Arbeitsauftrag kann lauten:

> Wählt einen fachlich geprüften API-Testfall aus der Testdokumentation aus und
> automatisiert ihn mit Robot Framework. Verändert den Anwendungscode nicht.

Damit erleben die Teilnehmenden die vollständige Verbindung von der Anforderung
über die Testdokumentation bis zum ausführbaren automatisierten Test.
