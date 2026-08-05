# Risikoanalyse: Hotel- und Chatfunktion

**Erstellt am:** 2026-08-04
**Grundlage:** `docs/testing/akzeptanzkriterien.md` (AC-CHAT-001 bis AC-CHAT-017), ergänzend `docs/testing/testbasis.md`

## Methodik und Kennzeichnung

- Jedes Risiko erhält eine ID im Format `R-CHAT-NNN`, eine Beschreibung, die
  betroffenen Akzeptanzkriterien, eine Auswirkungseinschätzung, eine grobe
  Eintrittswahrscheinlichkeit, eine daraus abgeleitete Priorität sowie
  vorgeschlagene Testideen (positiv, negativ, Grenzfälle).
- **Priorität** ergibt sich qualitativ aus Auswirkung × Eintrittswahrscheinlichkeit
  (jeweils Niedrig/Mittel/Hoch). Ein hohes Ergebnis in einer der beiden
  Dimensionen kann die Priorität auch bei niedriger Ausprägung der anderen
  Dimension anheben, wenn die Auswirkung auf den Kernbetrieb (Hotelbetrieb,
  vertrauliche Kommunikation) besonders schwer wiegt.
- **Genereller Vorbehalt (gilt für alle Einträge, sofern nicht anders
  vermerkt):** Es handelt sich um ein Trainingsprojekt ohne reale
  Nutzungshistorie und ohne Vorfalldaten. Jede Angabe zur
  Eintrittswahrscheinlichkeit ist daher grundsätzlich eine **fachliche
  ANNAHME** des Testers, keine belegte Kennzahl. Wo ein Defekt bereits durch
  Code-Prüfung bestätigt ist (siehe `docs/testing/analyse_20260804.md`), wird
  dies gesondert vermerkt — dort ist nicht das Auftreten selbst, sondern nur
  die Häufigkeit der tatsächlichen Auslösung im Betrieb eine Annahme.
- Diese Risikoanalyse ist ein **erster Entwurf**. Endgültige Priorisierung
  und Freigabe obliegen den fachlich Verantwortlichen (siehe `CLAUDE.md`,
  Definition of Done).

---

## R-CHAT-001: Raumübersicht zeigt unvollständige oder veraltete Daten

**Beschreibung:** Die Raumliste oder die Detailansicht eines Raums zeigt nicht alle vorhandenen Räume bzw. nicht den tatsächlich gespeicherten Belegungsstatus/Kategorie/Nummer an.

**Betroffene Akzeptanzkriterien:** AC-CHAT-001, AC-CHAT-002

**Auswirkung:** Rezeption trifft Belegungsentscheidungen auf Basis falscher Information — mögliche Folge: ein tatsächlich belegter Raum wird als frei angesehen (Doppelbelegung) oder ein freier Raum bleibt ungenutzt, weil er nicht in der Liste erscheint.

**Eintrittswahrscheinlichkeit:** Niedrig — einfache Lese-Operation ohne erkennbare Sonderfälle im Code. ANNAHME, da keine Testabdeckung existiert, die dies laufend prüft (siehe `testbasis.md`, Abschnitt 10).

**Priorität:** Mittel (niedrige Wahrscheinlichkeit, aber hohe Auswirkung auf den Kernprozess der Raumbelegung).

**Begründung der Priorisierung:** Der Raumüberblick ist die Grundlage jeder weiteren Rezeptionsentscheidung (Check-in, Statusänderung); ein Fehler hier wirkt sich auf nachgelagerte Prozesse aus.

**Testideen:**
- Positiv: Mehrere Räume mit unterschiedlichem Status anlegen (über vorhandene Seed-/Testdaten) und prüfen, dass alle in Liste und Detailansicht mit korrekter Nummer, Kategorie und Status erscheinen.
- Negativ: Detailabruf eines nicht existierenden Raums prüfen (erwartetes Verhalten dazu ist nicht Teil der bestätigten Akzeptanzkriterien — nur beobachten, nicht bewerten).
- Grenzfälle: Raumliste bei genau einem Raum bzw. bei sehr vielen Räumen prüfen.

**Fachliche Annahmen in dieser Bewertung:** Nur die allgemeine Einschränkung fehlender Nutzungsdaten (siehe Methodik).

---

## R-CHAT-002: Raumstatus wird nach Änderung nicht korrekt übernommen

**Beschreibung:** Eine von Rezeption vorgenommene Statusänderung eines Raums wird nicht oder falsch gespeichert, sodass der angezeigte Status vom zuletzt gesetzten Status abweicht.

**Betroffene Akzeptanzkriterien:** AC-CHAT-003

**Auswirkung:** Ein als „Cleaning" gemeldeter, tatsächlich aber weiterhin als „Available" geführter Raum könnte ungereinigt neu belegt werden — oder umgekehrt bleibt ein tatsächlich verfügbarer Raum fälschlich blockiert.

**Eintrittswahrscheinlichkeit:** Niedrig — einfache Schreiboperation. ANNAHME.

**Priorität:** Mittel.

**Begründung der Priorisierung:** Direkte Kernfunktion mit spürbarer betrieblicher Auswirkung, aber technisch einfacher Vorgang mit geringem Fehlerpotenzial.

**Testideen:**
- Positiv: Raumstatus auf jeden der drei möglichen Werte (Available, Occupied, Cleaning) ändern und nach jeder Änderung per erneutem Abruf verifizieren.
- Negativ: Statusänderung mit einem nicht in der Spezifikation genannten Wert versuchen (siehe R-CHAT-003).
- Grenzfälle: Mehrfache aufeinanderfolgende Statusänderungen desselben Raums kurz hintereinander.

**Fachliche Annahmen in dieser Bewertung:** Nur die allgemeine Einschränkung fehlender Nutzungsdaten.

---

## R-CHAT-003: Ein nicht spezifizierter Raumstatus wird akzeptiert

**Beschreibung:** Beim Ändern des Raumstatus wird ein Wert außerhalb der spezifizierten Menge (Available, Occupied, Cleaning) angenommen und gespeichert.

**Betroffene Akzeptanzkriterien:** AC-CHAT-003

**Auswirkung:** Ein Raum mit unbekanntem Status könnte in nachgelagerten Anzeigen (z. B. Verfügbarkeitszählung) nicht korrekt berücksichtigt werden.

**Eintrittswahrscheinlichkeit:** Niedrig — Grenzfall, der nur bei technisch ungewöhnlicher Eingabe (z. B. direkter API-Aufruf statt UI-Bedienung) auftritt. ANNAHME.

**Priorität:** Niedrig.

**Begründung der Priorisierung:** Geringe Auswirkung bei normaler UI-Bedienung, da die Oberfläche nur die drei gültigen Werte zur Auswahl anbietet; relevanter bei technischen Zugriffswegen außerhalb der UI, was jedoch außerhalb der fachlichen Testperspektive dieser Akzeptanzkriterien liegt.

**Testideen:**
- Grenzfälle: Statusänderung mit leerem, unbekanntem oder groß-/kleinschreibungsabweichendem Statuswert versuchen und das Ergebnis beobachten (ohne ein bestimmtes Verhalten vorab als „korrekt" vorauszusetzen, da hierzu keine bestätigte Anforderung vorliegt).

**Fachliche Annahmen in dieser Bewertung:** Diese Bewertung geht davon aus, dass ein solcher Fall in der Praxis selten über die reguläre Benutzeroberfläche auftritt — ANNAHME.

---

## R-CHAT-004: Gästeliste/Gastdetails zeigen unvollständige oder falsche Daten

**Beschreibung:** Analog zu R-CHAT-001, bezogen auf Gästeliste und Gastdetailansicht (Vorname, Nachname, zugewiesener Raum, Check-in-/Check-out-Datum).

**Betroffene Akzeptanzkriterien:** AC-CHAT-005, AC-CHAT-006

**Auswirkung:** Rezeption kann einen Gast nicht auffinden oder erhält falsche Aufenthaltsdaten — mögliche Folge: falsche Auskunft an Gäste oder Dritte, fehlerhafte Prozessentscheidungen.

**Eintrittswahrscheinlichkeit:** Niedrig. ANNAHME.

**Priorität:** Mittel.

**Testideen:**
- Positiv: Mehrere Gäste mit unterschiedlichem Aufenthaltsstatus (mit/ohne Raum, mit/ohne Check-out-Datum) anlegen und in Liste sowie Detailansicht auf Vollständigkeit prüfen.
- Grenzfälle: Gästeliste bei genau einem bzw. bei vielen Gästen.

**Fachliche Annahmen in dieser Bewertung:** Nur die allgemeine Einschränkung fehlender Nutzungsdaten.

---

## R-CHAT-005: Gast wird mit leerem oder nicht sinnvollem Namen angelegt

**Beschreibung:** Da keine serverseitige Prüfung auf Leerstring, Länge oder Format existiert (`testbasis.md`, Abschnitt 6, BELEGT), kann ein Gast mit leerem, extrem langem oder aus Sonderzeichen bestehendem Namen angelegt werden.

**Betroffene Akzeptanzkriterien:** AC-CHAT-004

**Auswirkung:** Ein Gast ist ggf. nicht eindeutig identifizierbar oder die Darstellung in Listen/Dokumenten wird beeinträchtigt.

**Eintrittswahrscheinlichkeit:** Mittel — das Fehlen der Validierung selbst ist BELEGT; ob dies in der Praxis tatsächlich zu problematischen Namenswerten führt, ist ANNAHME (abhängig vom Verhalten des Rezeptionspersonals).

**Priorität:** Niedrig-Mittel — die zugrunde liegende fachliche Erwartung (welche Namen zulässig sein sollen) ist in `testbasis.md`, Abschnitt 9, ausdrücklich als offene Frage geführt; eine abschließende Bewertung ist ohne diese Klärung nicht sinnvoll möglich.

**Begründung der Priorisierung:** Die technische Möglichkeit ist bestätigt, die fachliche Erheblichkeit hängt jedoch von einer noch offenen Anforderung ab — daher vorsichtig priorisiert, bis die offene Frage geklärt ist.

**Testideen:**
- Positiv: Gast mit üblichem Vor- und Nachnamen (inkl. Umlauten, siehe Decision 007) anlegen und Abruf verifizieren.
- Negativ: Gast mit leerem Vornamen bzw. Nachnamen anlegen und beobachten, ob dies angenommen wird.
- Grenzfälle: Sehr langer Name (z. B. mehrere hundert Zeichen), Name ausschließlich aus Leerzeichen, Name mit Steuerzeichen.

**Fachliche Annahmen in dieser Bewertung:** Die fachliche Erheblichkeit dieses Risikos hängt von der offenen Frage zu Namensvalidierung ab (`testbasis.md`, Abschnitt 9) — ausdrücklich als Annahme gekennzeichnet.

---

## R-CHAT-006: Gastdaten gehen bei Bearbeitung verloren oder werden falsch übernommen

**Beschreibung:** Beim Ändern von Vor-/Nachname eines Gastes wird der neue Wert nicht oder nur teilweise gespeichert, oder ein anderes Feld wird unbeabsichtigt verändert.

**Betroffene Akzeptanzkriterien:** AC-CHAT-007

**Auswirkung:** Fehlerhafte Gastdaten in nachfolgenden Prozessen (z. B. Kommunikation, Dokumente).

**Eintrittswahrscheinlichkeit:** Niedrig. ANNAHME.

**Priorität:** Niedrig-Mittel.

**Testideen:**
- Positiv: Vorname und Nachname eines bestehenden Gastes ändern, danach abrufen und mit dem neuen Wert vergleichen.
- Grenzfälle: Nur eines der beiden Felder ändern, das andere unverändert lassen und prüfen, dass es tatsächlich unverändert bleibt.

**Fachliche Annahmen in dieser Bewertung:** Nur die allgemeine Einschränkung fehlender Nutzungsdaten.

---

## R-CHAT-007: Gast wird trotz laufendem Aufenthalt bzw. mit Verlust relevanter Historie gelöscht

**Beschreibung:** Ein Gast wird gelöscht, wodurch ggf. vorhandene historische Check-in-/Check-out-Daten unwiderruflich verloren gehen, da keine Historientabelle existiert.

**Betroffene Akzeptanzkriterien:** AC-CHAT-008

**Auswirkung:** Verlust von Aufenthaltsnachweisen, die für spätere Auskünfte (z. B. gegenüber dem Gast) benötigt werden könnten.

**Eintrittswahrscheinlichkeit:** Mittel — das Löschverhalten selbst ist über die Anwendung regulär auslösbar.

**Priorität:** Mittel — abhängig von einer offenen fachlichen Frage.

**Begründung der Priorisierung:** Ob der Verlust historischer Daten überhaupt unerwünscht ist, ist laut `testbasis.md`, Abschnitt 9, offen; die Priorität kann erst nach Klärung dieser Frage abschließend bestimmt werden.

**Testideen:**
- Positiv: Gast ohne jegliche Aufenthaltshistorie (nie eingecheckt) löschen und Nichtverfügbarkeit danach prüfen.
- Negativ/Grenzfall: Gast mit vorhandenem Check-in-/Check-out-Datum (aber aktuell ohne zugewiesenen Raum) löschen und beobachten, ob und wie die historischen Daten dabei behandelt werden.

**Fachliche Annahmen in dieser Bewertung:** Die Bewertung, dass ein Datenverlust hier überhaupt unerwünscht wäre, ist eine Annahme — die zugrunde liegende Frage ist ausdrücklich offen (`testbasis.md`, Abschnitt 9).

---

## R-CHAT-008: Check-in setzt nicht alle erforderlichen Effekte konsistent um

**Beschreibung:** Beim Check-in wird nur ein Teil der drei erwarteten Effekte (Raumzuweisung, Statuswechsel auf Occupied, Speicherung des Check-in-Datums) tatsächlich umgesetzt.

**Betroffene Akzeptanzkriterien:** AC-CHAT-009

**Auswirkung:** Inkonsistenter Systemzustand — z. B. ein Raum gilt als belegt, ohne dass ein Gast zugeordnet ist, oder umgekehrt; dies kann zu falschen Verfügbarkeitsanzeigen und Doppelbelegungen führen.

**Eintrittswahrscheinlichkeit:** Niedrig — die drei Effekte werden im Code als zusammenhängender Ablauf umgesetzt. ANNAHME, da nicht durch einen Test abgesichert.

**Priorität:** Hoch — trotz niedriger Wahrscheinlichkeit hat eine Inkonsistenz an dieser Stelle unmittelbare Auswirkung auf den zentralen Geschäftsprozess der Zimmerbelegung.

**Begründung der Priorisierung:** Check-in ist der zentrale Prozessschritt, der Raumbelegung und Gastzuordnung verknüpft; ein Fehler hier hat Kaskadenwirkung auf alle nachgelagerten Prozesse (Check-out, Raumverfügbarkeit, Kommunikation).

**Testideen:**
- Positiv: Gast ohne Raum und verfügbaren Raum verwenden, Check-in durchführen, danach alle drei Effekte einzeln verifizieren (Raumzuweisung beim Gast, Status beim Raum, Datum beim Gast).
- Grenzfälle: Check-in unmittelbar nach Anlage des Gastes bzw. unmittelbar nach einer vorherigen Statusänderung des Raums durchführen.

**Fachliche Annahmen in dieser Bewertung:** Nur die allgemeine Einschränkung fehlender Nutzungsdaten.

---

## R-CHAT-009: Gleichzeitiger Check-in mehrerer Gäste auf denselben Raum

**Beschreibung:** Bei nahezu zeitgleichen Check-in-Anfragen auf denselben Raum könnte dieser Raum zwei Gästen gleichzeitig zugewiesen werden (Race Condition).

**Betroffene Akzeptanzkriterien:** AC-CHAT-009

**Auswirkung:** Doppelbelegung eines Zimmers — hohe operative und Reputationsauswirkung, falls tatsächlich zwei Gäste demselben Zimmer zugewiesen werden.

**Eintrittswahrscheinlichkeit:** Niedrig — erfordert exakt zeitgleiche Anfragen, was im typischen Rezeptionsbetrieb (eine Bedienperson, sequenzielle Eingabe) selten ist. **Ausdrücklich als ANNAHME gekennzeichnet**, da weder ein Test noch eine Dokumentation dazu vorliegt (`testbasis.md`, Abschnitt 8).

**Priorität:** Mittel — niedrige Wahrscheinlichkeit, aber schwerwiegende Auswirkung im Eintrittsfall.

**Begründung der Priorisierung:** Klassische Konstellation „selten, aber schwerwiegend"; Aufwand für einen belastbaren Test (parallele Anfragen) ist höher als bei den übrigen Kernfunktionsrisiken, daher nicht die höchste Priorität, aber nicht vernachlässigbar.

**Testideen:**
- Grenzfälle: Zwei nahezu zeitgleiche Check-in-Anfragen auf denselben verfügbaren Raum mit unterschiedlichen Gästen auslösen und prüfen, ob der Raum tatsächlich nur einem Gast zugewiesen wird.

**Fachliche Annahmen in dieser Bewertung:** Sowohl die Eintrittswahrscheinlichkeit als auch die Annahme, dass Rezeptionsbetrieb überwiegend sequenziell erfolgt, sind ausdrücklich Annahmen ohne Beleg in den Quellen.

---

## R-CHAT-010: Check-out gibt den Raum ungereinigt direkt zur Neubelegung frei

**Beschreibung:** Nach dem Check-out wird der Raum nicht mit dem Status „Cleaning" geführt, sondern direkt als „Available", sodass er ohne zwischenzeitliche Reinigung erneut belegt werden könnte.

**Betroffene Akzeptanzkriterien:** AC-CHAT-010

**Auswirkung:** Ein Gast könnte ein ungereinigtes Zimmer beziehen — direkte, spürbare Auswirkung auf die Servicequalität und den Ruf des Hotels.

**Eintrittswahrscheinlichkeit:** Niedrig — die Anforderung ist im Code eindeutig als fester Zielstatus umgesetzt (`app/services/checkinout_service.py`, Zeile 33, laut `testbasis.md` Abschnitt 6). ANNAHME bezüglich fehlender Testabsicherung.

**Priorität:** Hoch — diese Anforderung ist wörtlich in `specs/basis_spec.md` (Zeile 98) benannt und hat unmittelbare Auswirkung auf die Servicequalität; ein Regressionsfehler an dieser Stelle wäre besonders schwerwiegend.

**Begründung der Priorisierung:** Explizite Spezifikationsanforderung mit direkter Auswirkung auf Hygiene-/Servicequalität; sollte unabhängig von der aktuell geringen Fehlerwahrscheinlichkeit hoch priorisiert bleiben, u. a. als Regressionsschutz.

**Testideen:**
- Positiv: Gast mit zugewiesenem Raum auschecken und unmittelbar danach den Raumstatus prüfen (erwartet: Cleaning, nicht Available).
- Grenzfälle: Check-out unmittelbar nach Check-in desselben Gastes (kürzestmöglicher Aufenthalt).

**Fachliche Annahmen in dieser Bewertung:** Nur die allgemeine Einschränkung fehlender Nutzungsdaten; die Anforderung selbst ist belegt (Spezifikation + Code übereinstimmend).

---

## R-CHAT-011: Nachricht wird dem falschen Zimmer zugeordnet

**Beschreibung:** Eine gesendete Nachricht wird einem anderen als dem ausgewählten Zielraum zugeordnet gespeichert oder bei der raumgefilterten Abfrage einem falschen Raum zugerechnet.

**Betroffene Akzeptanzkriterien:** AC-CHAT-011, AC-CHAT-013, AC-CHAT-016

**Auswirkung:** Potenziell vertrauliche Kommunikation erreicht den falschen Gast, oder eine wichtige Information (z. B. Weckruf, Serviceankündigung) erreicht den beabsichtigten Gast nicht. Dies ist eine der schwerwiegendsten denkbaren Auswirkungen im Chat-Kontext.

**Eintrittswahrscheinlichkeit:** Niedrig — die Raumzuordnung erfolgt über einen einfachen, direkten Fremdschlüsselbezug ohne erkennbare Zwischenschritte. ANNAHME, mangels Testabdeckung.

**Priorität:** Hoch — sehr hohe Auswirkung bei ohnehin schon geringer, aber nicht auszuschließender Fehlerwahrscheinlichkeit.

**Begründung der Priorisierung:** Direkter Bezug zu Vertraulichkeit und Zuverlässigkeit der Gästekommunikation — eine der in der Aufgabenstellung explizit benannten Kernfragen („Könnte eine Nachricht dem falschen Zimmer zugeordnet werden?").

**Testideen:**
- Positiv: Nachrichten an mehrere unterschiedliche Räume senden und für jeden Raum einzeln per Filter/Gastsicht verifizieren, dass ausschließlich die für diesen Raum bestimmten Nachrichten erscheinen.
- Negativ: Nachricht an einen nicht existierenden Zielraum senden und Verhalten beobachten (kein bestätigtes erwartetes Ergebnis vorhanden, siehe `akzeptanzkriterien.md` „Nicht ableitbare Akzeptanzkriterien").
- Grenzfälle: Mehrere Nachrichten kurz hintereinander an unterschiedliche Räume senden und Zuordnung nach jeder einzelnen Aktion prüfen.

**Fachliche Annahmen in dieser Bewertung:** Nur die allgemeine Einschränkung fehlender Nutzungsdaten.

---

## R-CHAT-012: Nachrichteninhalt wird unvollständig oder verändert gespeichert

**Beschreibung:** Der beim Senden eingegebene Nachrichtentext wird nicht unverändert gespeichert oder angezeigt (z. B. Verlust von Sonderzeichen, Kürzung).

**Betroffene Akzeptanzkriterien:** AC-CHAT-011, AC-CHAT-014

**Auswirkung:** Kommunikationsinhalt wird verfälscht — Gast oder Rezeption erhält eine andere Information als beabsichtigt.

**Eintrittswahrscheinlichkeit:** Niedrig — Nachrichtentext wird laut Code unverändert als Freitext gespeichert (`app/repositories/message_repository.py`). ANNAHME bezüglich fehlender Testabsicherung.

**Priorität:** Mittel.

**Testideen:**
- Positiv: Nachricht mit Umlauten, Satzzeichen und Zahlen senden und exakten Wortlaut beim Abruf vergleichen.
- Grenzfälle: Sehr lange Nachricht senden und prüfen, ob sie vollständig oder gekürzt gespeichert wird (siehe auch R-CHAT-016).

**Fachliche Annahmen in dieser Bewertung:** Nur die allgemeine Einschränkung fehlender Nutzungsdaten.

---

## R-CHAT-013: Nachricht geht verloren oder wird doppelt gespeichert

**Beschreibung:** Eine gesendete Nachricht erscheint nicht in der Nachrichtenliste, oder ein einzelner Sendevorgang erzeugt mehr als einen Nachrichtendatensatz.

**Betroffene Akzeptanzkriterien:** AC-CHAT-011, AC-CHAT-012

**Auswirkung:** Verlust: Information erreicht den Empfänger nicht. Duplikat: Verwirrung, ggf. mehrfache Reaktion auf dieselbe Anfrage.

**Eintrittswahrscheinlichkeit:** Niedrig für einfaches Senden über die Oberfläche. Für den automatischen Statuswechsel der Gastsicht (mehrere `PATCH`-Aufrufe beim Laden, siehe `testbasis.md` Abschnitt 6/8) ist ein doppelter Aufruf bei parallel geöffneten Ansichten denkbar — **ANNAHME**, nicht getestet.

**Priorität:** Mittel.

**Testideen:**
- Positiv: Einzelne Nachricht senden und genau einmal in der Liste wiederfinden.
- Grenzfälle: Gastsicht desselben Raums in zwei Browser-Tabs gleichzeitig öffnen und beobachten, ob dies zu unerwarteten Zuständen führt (manueller Testfall, siehe Hinweis zu Nebenläufigkeit).

**Fachliche Annahmen in dieser Bewertung:** Die Einschätzung zur Gastsicht-Nebenläufigkeit ist eine Annahme, da kein Test vorliegt.

---

## R-CHAT-014: Nachrichtenfilter nach Raum liefert falsche Ergebnisse

**Beschreibung:** Die raumgefilterte Nachrichtenliste zeigt Nachrichten anderer Räume oder blendet Nachrichten des gewählten Raums fälschlich aus.

**Betroffene Akzeptanzkriterien:** AC-CHAT-013

**Auswirkung:** Rezeption verliert den Überblick über die Kommunikation eines bestimmten Zimmers; im schlimmsten Fall werden fremde Nachrichten sichtbar (Vertraulichkeit, siehe auch R-CHAT-011).

**Eintrittswahrscheinlichkeit:** Niedrig. ANNAHME.

**Priorität:** Mittel-Hoch (Überschneidung mit Vertraulichkeitsaspekt aus R-CHAT-011).

**Testideen:**
- Positiv: Nachrichten an mindestens zwei unterschiedliche Räume senden, danach nach jeweils einem Raum filtern und prüfen, dass nur dessen Nachrichten erscheinen.
- Grenzfälle: Filter auf einen Raum ohne jegliche Nachrichten anwenden (erwartete leere Liste).

**Fachliche Annahmen in dieser Bewertung:** Nur die allgemeine Einschränkung fehlender Nutzungsdaten.

---

## R-CHAT-015: Nachrichtenstatus stimmt nicht mit dem tatsächlichen Zustand überein

**Beschreibung:** Der angezeigte Status einer Nachricht (sent/delivered/read) entspricht nicht dem zuletzt gesetzten bzw. fachlich erwarteten Zustand.

**Betroffene Akzeptanzkriterien:** AC-CHAT-015

**Auswirkung:** Rezeption könnte fälschlich annehmen, eine wichtige Nachricht sei bereits gelesen worden, und auf ein Nachfassen verzichten — eine der in der Aufgabenstellung explizit benannten Kernfragen.

**Eintrittswahrscheinlichkeit:** Niedrig für die reine Anzeige des gespeicherten Status. ANNAHME.

**Priorität:** Hoch — direkter Bezug zu User Story 3 der Spezifikation („I want to see whether a message was read") und potenziell schwerwiegende Auswirkung, wenn Rezeption sich auf eine falsche Statusanzeige verlässt.

**Begründung der Priorisierung:** Auch bei geringer technischer Fehlerwahrscheinlichkeit ist die fachliche Bedeutung dieser Information (Vertrauen in den angezeigten Status) hoch.

**Testideen:**
- Positiv: Nachricht senden, Status abrufen (erwartet: sent), danach den Status ändern und erneut abrufen.
- Grenzfälle: Status unmittelbar nach dem Senden mehrfach hintereinander abrufen und auf Konsistenz prüfen.

**Fachliche Annahmen in dieser Bewertung:** Was genau „delivered" fachlich bedeuten soll, ist laut `testbasis.md` Abschnitt 9 offen — die Bewertung der Auswirkung geht davon aus, dass Rezeption dem angezeigten Status grundsätzlich vertraut; dies ist eine Annahme.

---

## R-CHAT-016: Leere oder ungewöhnlich lange Nachrichten werden ohne erkennbare Handhabung angenommen

**Beschreibung:** Da keine serverseitige Prüfung auf Leerstring oder maximale Länge für den Nachrichtentext existiert (`testbasis.md`, Abschnitt 6, BELEGT), können leere oder extrem lange Nachrichten gesendet und gespeichert werden.

**Betroffene Akzeptanzkriterien:** AC-CHAT-011

**Auswirkung:** Eine augenscheinlich leere oder unverhältnismäßig lange Nachricht könnte die Darstellung in Liste/Detailansicht beeinträchtigen oder als bedeutungslose Kommunikation wahrgenommen werden.

**Eintrittswahrscheinlichkeit:** Mittel — die technische Möglichkeit ist bestätigt (BELEGT); ob dies in der Praxis vorkommt, ist ANNAHME.

**Priorität:** Niedrig — es liegt keine bestätigte fachliche Anforderung zu zulässigen Längen oder Inhalten vor (siehe `akzeptanzkriterien.md`), eine abschließende Bewertung der Erheblichkeit ist daher nicht möglich.

**Testideen:**
- Grenzfälle: Nachricht mit ausschließlich Leerzeichen senden; sehr lange Nachricht (z. B. mehrere tausend Zeichen) senden; Ergebnis jeweils beobachten, ohne ein bestimmtes Verhalten als „korrekt" vorauszusetzen.

**Fachliche Annahmen in dieser Bewertung:** Die fachliche Erheblichkeit ist nicht spezifiziert (offene Frage, `testbasis.md` Abschnitt 9) — die hier vorgenommene niedrige Priorisierung ist eine vorläufige Einschätzung, keine belegte Bewertung.

---

## R-CHAT-017: Eingeschleuster Code in Nachrichteninhalt oder Sender wird beim Anzeigen ausgeführt (XSS)

**Beschreibung:** Nachrichteninhalt und Sender-Wert werden im Frontend ohne Zeichenkodierung direkt in die Seite eingefügt (bestätigt durch Code-Prüfung, `docs/testing/analyse_20260804.md`, Abschnitt 5.1). Ein als Nachrichtentext oder Sender eingegebenes Skript kann dadurch beim Anzeigen aktiv ausgeführt werden.

**Betroffene Akzeptanzkriterien:** AC-CHAT-012, AC-CHAT-014, AC-CHAT-016 (jeweils die Anzeige einer Nachricht)

**Auswirkung:** Ausführung von eingeschleustem Code im Browser jeder Person, die die betroffene Nachricht ansieht — potenziell Diebstahl von Sitzungsdaten, Manipulation der angezeigten Seite oder Weiterleitung auf andere Seiten. Da sowohl Rezeptions- als auch Gastsicht betroffen sind und Nachrichten über die unauthentifizierte Gastsicht frei einspeisbar sind, ist der Angriffsweg ohne Zusatzwissen nutzbar.

**Eintrittswahrscheinlichkeit:** Hoch — der zugrunde liegende Defekt ist **BELEGT** durch Code-Prüfung (nicht durch Annahme). Ob er in der Praxis ausgenutzt wird, hängt vom Verhalten der Nutzenden ab; dies bleibt ANNAHME, ändert aber nichts an der bestätigten technischen Auslösbarkeit.

**Priorität:** Hoch.

**Begründung der Priorisierung:** Kombination aus bestätigtem Defekt und hoher Auswirkung (Codeausführung im Browser Dritter) ergibt die höchste Priorität in dieser Analyse.

**Testideen:**
- Negativ: Nachricht mit einfachem HTML-Markup (z. B. Formatierungs-Tag) als Inhalt senden und beobachten, ob dieses als aktives Markup statt als Text angezeigt wird.
- Negativ: Nachricht mit einem Skript-artigen Inhalt senden und beobachten, ob eine Ausführung im Browser der Rezeptions- bzw. Gastsicht erfolgt.
- Negativ: Denselben Versuch über das Sender-Feld der Rezeptionssicht durchführen.
- Grenzfälle: Kombination aus mehreren HTML-Sonderzeichen im selben Nachrichtentext.

**Fachliche Annahmen in dieser Bewertung:** Nur die Häufigkeit der tatsächlichen Ausnutzung im Betrieb ist Annahme; die technische Auslösbarkeit ist belegt.

---

## R-CHAT-018: Nachrichten oder Sender-Identität eines fremden Raums werden sichtbar bzw. vortäuschbar

**Beschreibung:** Da der Zugriff auf die Gastsicht ausschließlich über die Raum-ID ohne Authentifizierung erfolgt und der Sender-Wert ungeprüfter Freitext ist, kann grundsätzlich jede Person mit Kenntnis einer Raum-ID die Nachrichten dieses Raums einsehen bzw. Nachrichten unter einer beliebigen Sender-Bezeichnung senden.

**Betroffene Akzeptanzkriterien:** AC-CHAT-016 (mittelbar auch AC-CHAT-011, soweit der Sender-Wert betroffen ist)

**Auswirkung:** Vertrauliche Kommunikation eines Zimmers könnte für unbeteiligte Dritte sichtbar sein; eine Nachricht könnte fälschlich als von der Rezeption oder von einem bestimmten Gast stammend erscheinen.

**Eintrittswahrscheinlichkeit:** Diese Eigenschaft ist als bewusste, dokumentierte Scope-Grenze des Projekts BELEGT (`specs/basis_spec.md`, Zeile 34; `docs/decisions.md` Decision 008) und tritt bei Kenntnis einer Raum-ID zuverlässig ein — dies ist kein Zufallsdefekt, sondern die dokumentierte Funktionsweise.

**Priorität:** Hoch bezüglich der fachlichen Auswirkung, jedoch **kein Produktfehler**, sondern dokumentierte Scope-Grenze — die Priorität bezieht sich hier auf den Bedarf, dieses Risiko transparent zu kommunizieren und im Testumfang bewusst zu berücksichtigen, nicht auf eine zu behebende Abweichung.

**Begründung der Priorisierung:** Hohe fachliche Tragweite (Vertraulichkeit), aber explizit außerhalb dessen, was im Rahmen dieses Projekts als Mangel gilt (Auth ist laut Spezifikation nicht Teil des Systems). Aufgenommen, damit dieses Risiko nicht versehentlich als Testlücke missverstanden wird.

**Testideen:**
- Positiv: Zugriff auf die Gastsicht mit einer bekannten, gültigen Raum-ID und Verifikation, dass die Nachrichten des jeweiligen Raums angezeigt werden (deckt sich mit AC-CHAT-016).
- Grenzfälle: Beobachtung (nicht Bewertung als Fehler), was bei Zugriff mit einer Raum-ID eines anderen, tatsächlich belegten Zimmers sichtbar ist.

**Fachliche Annahmen in dieser Bewertung:** Keine hinsichtlich des Auftretens (belegte Scope-Grenze); die Einschätzung, dass dies für Testzwecke dennoch dokumentiert werden sollte, ist eine fachliche Empfehlung, keine Feststellung eines Mangels.

---

## R-CHAT-019: Nachrichtenhistorie geht nach einem Neustart der Anwendung verloren

**Beschreibung:** Nach einem Neustart der Anwendung sind zuvor gesendete Nachrichten nicht mehr vorhanden oder inhaltlich verändert.

**Betroffene Akzeptanzkriterien:** AC-CHAT-017

**Auswirkung:** Vollständiger Verlust der bisherigen Kommunikationshistorie zwischen Rezeption und Gästen — schwerwiegend, da die Spezifikation dauerhafte Speicherung explizit fordert.

**Eintrittswahrscheinlichkeit:** Niedrig — Nachrichten werden in einer dateibasierten SQLite-Datenbank persistiert, nicht im Arbeitsspeicher (`app/database.py`). ANNAHME bezüglich fehlender Testabsicherung.

**Priorität:** Hoch — explizite Spezifikationsanforderung („shall remain available after application restart"); ein Fehler hier würde eine wörtliche Anforderung verletzen.

**Testideen:**
- Positiv: Nachricht senden, Anwendung neu starten, danach die Nachricht unverändert wiederfinden (manueller Testfall, Neustart ist kein regulärer API-/UI-Vorgang).

**Fachliche Annahmen in dieser Bewertung:** Nur die allgemeine Einschränkung fehlender Nutzungsdaten.

---

## R-CHAT-020: Fehlende automatisierte Testabdeckung verhindert das Erkennen von Regressionen

**Beschreibung:** Für keine der in den Akzeptanzkriterien beschriebenen Funktionen existiert aktuell ein automatisierter Test (`testbasis.md`, Abschnitt 6 und 10, BELEGT).

**Betroffene Akzeptanzkriterien:** Alle (AC-CHAT-001 bis AC-CHAT-017)

**Auswirkung:** Jede zukünftige Codeänderung kann eine der oben beschriebenen Anforderungen brechen, ohne dass dies vor einer manuellen Prüfung auffällt — erhöhtes Risiko für alle anderen in dieser Analyse genannten Risiken.

**Eintrittswahrscheinlichkeit:** Das Fehlen der Testabdeckung selbst ist BELEGT (kein `tests/`-Verzeichnis vorhanden); die Wahrscheinlichkeit, dass dies zu einer unbemerkten Regression führt, ist ANNAHME und steigt mit jeder weiteren Codeänderung.

**Priorität:** Hoch — Querschnittsrisiko, das die Wirksamkeit aller anderen Risikominderungen (Tests) einschränkt, zusätzlich im Widerspruch zu einer wörtlichen Anforderung beider Spezifikationen (siehe `testbasis.md`, Abschnitt 10).

**Begründung der Priorisierung:** Dieses Risiko wirkt nicht auf eine einzelne Funktion, sondern auf die Verlässlichkeit aller übrigen Feststellungen dieser Analyse.

**Testideen:**
- Kein klassischer positiv/negativ-Test im fachlichen Sinn; die Testidee besteht im Aufbau der in `testfaelle.md` vorzusehenden automatisierten Abdeckung für die in dieser Risikoanalyse und den Akzeptanzkriterien beschriebenen Verhaltensweisen.

**Fachliche Annahmen in dieser Bewertung:** Nur die allgemeine Einschränkung fehlender Nutzungsdaten; das Fehlen der Tests selbst ist belegt.

---

## R-CHAT-021: Fehlgeschlagene Aktionen bleiben im Frontend ohne erkennbare Rückmeldung

**Beschreibung:** Weder die Rezeptions- noch die Gastsicht der Chatfunktion prüfen den Ergebnisstatus nach dem Senden einer Nachricht oder einer Statusänderung (`testbasis.md`, Abschnitt 6, BELEGT). Das Eingabefeld wird auch bei einem fehlgeschlagenen Sendevorgang geleert.

**Betroffene Akzeptanzkriterien:** AC-CHAT-011, AC-CHAT-016 (mittelbar auch AC-CHAT-009/010, da vergleichbare Fetch-Aufrufe verwendet werden)

**Auswirkung:** Rezeption oder Gast gehen fälschlich davon aus, eine Nachricht sei erfolgreich gesendet worden, obwohl dies nicht der Fall war — die erwartete Kommunikation findet faktisch nicht statt, ohne dass dies bemerkt wird.

**Eintrittswahrscheinlichkeit:** Das Fehlen der Rückmeldung selbst ist BELEGT; wie oft tatsächlich Sendefehler auftreten (z. B. durch zwischenzeitlich gelöschte Räume), ist ANNAHME.

**Priorität:** Mittel.

**Begründung der Priorisierung:** Die Auswirkung ist potenziell hoch (verpasste Kommunikation, siehe auch R-CHAT-011/013), tritt jedoch nur in Kombination mit einem vorgelagerten Fehlerfall auf, dessen eigene Wahrscheinlichkeit als niedrig eingeschätzt wird.

**Testideen:**
- Grenzfälle: Nachricht an eine zuvor gültige, aber inzwischen ungültige Raumreferenz senden (z. B. durch vorheriges Löschen der Testdaten, falls möglich) und beobachten, ob eine erkennbare Rückmeldung erfolgt.

**Fachliche Annahmen in dieser Bewertung:** Die Einschätzung, wie häufig Sendefehler in der Praxis auftreten, ist eine Annahme.

---

## Zusammenfassung nach Priorität

**Hoch:**
R-CHAT-008 (Check-in-Konsistenz), R-CHAT-010 (Checkout → Cleaning), R-CHAT-011 (Nachricht falschem Zimmer zugeordnet), R-CHAT-015 (Nachrichtenstatus falsch), R-CHAT-017 (XSS), R-CHAT-018 (Vertraulichkeit ohne Auth — dokumentierte Scope-Grenze, kein Fehler), R-CHAT-019 (Persistenz nach Neustart), R-CHAT-020 (fehlende Testabdeckung)

**Mittel:**
R-CHAT-001, R-CHAT-002, R-CHAT-004, R-CHAT-005, R-CHAT-006, R-CHAT-007, R-CHAT-009, R-CHAT-012, R-CHAT-013, R-CHAT-014, R-CHAT-021

**Niedrig:**
R-CHAT-003, R-CHAT-016

Diese Priorisierung ist ein Entwurf und bedarf der fachlichen Bestätigung, insbesondere dort, wo die Bewertung ausdrücklich als von offenen Fragen abhängig gekennzeichnet ist (R-CHAT-005, R-CHAT-007, R-CHAT-015, R-CHAT-016).

---

**Ende der Risikoanalyse**
