# Akzeptanzkriterien: Hotel- und Chatfunktion

**Erstellt am:** 2026-08-04
**Grundlage:** `docs/testing/testbasis.md`, Abschnitt 7 „Belegte fachliche Anforderungen"

## Ableitungsregeln (angewendet)

- Jedes Kriterium unten leitet sich ausschließlich aus einer in
  `testbasis.md` Abschnitt 7 als **belegte fachliche Anforderung** geführten
  Aussage ab, mit direktem Bezug auf die zugrunde liegende Spezifikation.
- Anforderungen, die in `testbasis.md` Abschnitt 6 („Bekannte
  Rahmenbedingungen und Einschränkungen") als **Implementierungsentscheidung**
  gekennzeichnet sind — also implementiertes, aber nicht spezifiziertes
  Verhalten — wurden **nicht** in ein Akzeptanzkriterium überführt, auch wenn
  sie technisch beobachtbar sind. Sie stehen stattdessen im Abschnitt „Nicht
  ableitbare Akzeptanzkriterien".
- Die nicht-funktionalen Anforderungen aus `testbasis.md` Abschnitt 7
  (Technologie-Stack, Schichtenarchitektur, Testpflicht) sind keine als
  Gegeben–Wenn–Dann beobachtbaren Verhaltensweisen der laufenden Anwendung
  und wurden daher nicht in Akzeptanzkriterien überführt (Ausnahme: die
  Testpflicht wird im Abschnitt „Nicht ableitbare Akzeptanzkriterien"
  aufgeführt, da sie im Widerspruch zum aktuellen Repository-Zustand steht).

---

## AC-CHAT-001: Räume auflisten

**Anforderung:**
Rezeption kann alle vorhandenen Räume auflisten.

**Quelle:**
- `specs/basis_spec.md`, Abschnitt „Room Management" (Zeile 56: „List rooms")

**Gegeben** ein oder mehrere Räume sind im System vorhanden,

**Wenn** Rezeption die Liste aller Räume abruft,

**Dann** werden alle vorhandenen Räume in der Liste angezeigt.

**Offene Bezüge:**
- Keine

---

## AC-CHAT-002: Raumdetails ansehen

**Anforderung:**
Rezeption kann die Details eines einzelnen Raums ansehen, einschließlich
Raumnummer, Kategorie und Belegungsstatus.

**Quelle:**
- `specs/basis_spec.md`, Abschnitt „Room Management" (Zeilen 42-46: „A room
  contains: Room number, Category, Occupancy status"; Zeile 57: „View room
  details")

**Gegeben** ein Raum mit Raumnummer, Kategorie und Belegungsstatus existiert,

**Wenn** Rezeption die Details dieses Raums abruft,

**Dann** werden Raumnummer, Kategorie und Belegungsstatus des Raums
angezeigt.

**Offene Bezüge:**
- Keine

---

## AC-CHAT-003: Raumstatus ändern

**Anforderung:**
Rezeption kann den Belegungsstatus eines Raums ändern.

**Quelle:**
- `specs/basis_spec.md`, Abschnitt „Room Management" (Zeile 58: „Change room
  status"; Zeilen 48-52: mögliche Status Available, Occupied, Cleaning)

**Gegeben** ein Raum mit einem der Status Available, Occupied oder Cleaning
existiert,

**Wenn** Rezeption den Belegungsstatus dieses Raums auf einen der Werte
Available, Occupied oder Cleaning ändert,

**Dann** wird der neue Belegungsstatus gespeichert und beim Abruf des Raums
angezeigt.

**Offene Bezüge:**
- Keine

---

## AC-CHAT-004: Gast anlegen

**Anforderung:**
Rezeption kann einen neuen Gast mit Vorname und Nachname anlegen.

**Quelle:**
- `specs/basis_spec.md`, Abschnitt „Guest Management" (Zeilen 66-67: „First
  name", „Last name"; Zeile 74: „Create guests")

**Gegeben** ein Vorname und ein Nachname sind angegeben,

**Wenn** Rezeption einen neuen Gast mit diesem Vor- und Nachnamen anlegt,

**Dann** wird der Gast gespeichert und ist mit dem angegebenen Vor- und
Nachnamen abrufbar.

**Offene Bezüge:**
- OFFEN (`testbasis.md`, Abschnitt 9): Anforderungen an Länge oder Format
  von Gastnamen sind nicht spezifiziert.

---

## AC-CHAT-005: Gästeliste abrufen

**Anforderung:**
Rezeption kann alle vorhandenen Gäste auflisten.

**Quelle:**
- `specs/basis_spec.md`, Abschnitt „Guest Management" (Zeile 75: „View
  guests")

**Gegeben** ein oder mehrere Gäste sind im System vorhanden,

**Wenn** Rezeption die Liste aller Gäste abruft,

**Dann** werden alle vorhandenen Gäste in der Liste angezeigt.

**Offene Bezüge:**
- Keine

---

## AC-CHAT-006: Gastdetails ansehen

**Anforderung:**
Rezeption kann die Details eines einzelnen Gastes ansehen, einschließlich
Vorname, Nachname, zugewiesenem Raum, Check-in-Datum und Check-out-Datum.

**Quelle:**
- `specs/basis_spec.md`, Abschnitt „Guest Management" (Zeilen 66-70: „First
  name, Last name, Assigned room, Check-in date, Check-out date"; Zeile 75:
  „View guests")

**Gegeben** ein Gast mit Vorname und Nachname existiert,

**Wenn** Rezeption die Details dieses Gastes abruft,

**Dann** werden Vorname, Nachname, zugewiesener Raum, Check-in-Datum und
Check-out-Datum des Gastes angezeigt.

**Offene Bezüge:**
- Keine

---

## AC-CHAT-007: Gast bearbeiten

**Anforderung:**
Rezeption kann Vorname und Nachname eines Gastes ändern.

**Quelle:**
- `specs/basis_spec.md`, Abschnitt „Guest Management" (Zeile 76: „Update
  guests")

**Gegeben** ein Gast existiert,

**Wenn** Rezeption Vorname und/oder Nachname dieses Gastes ändert,

**Dann** wird der geänderte Vor- bzw. Nachname gespeichert und ist beim
Abruf des Gastes sichtbar.

**Offene Bezüge:**
- Keine

---

## AC-CHAT-008: Gast löschen

**Anforderung:**
Rezeption kann einen Gast löschen.

**Quelle:**
- `specs/basis_spec.md`, Abschnitt „Guest Management" (Zeile 77: „Delete
  guests")

**Gegeben** ein Gast existiert,

**Wenn** Rezeption diesen Gast löscht,

**Dann** ist der Gast danach nicht mehr abrufbar.

**Offene Bezüge:**
- OFFEN (`testbasis.md`, Abschnitt 9): Ob das Löschen eines Gastes
  inklusive seiner historischen Check-in-/Check-out-Daten fachlich gewollt
  ist, ist nicht spezifiziert.

---

## AC-CHAT-009: Gast einchecken

**Anforderung:**
Rezeption kann einem Gast einen Raum zuweisen, den Raum als belegt
markieren und das Check-in-Datum speichern.

**Quelle:**
- `specs/basis_spec.md`, Abschnitt „Check-In" (Zeilen 85-87: „Assign a room
  to a guest", „Mark the room as occupied", „Store check-in date")

**Gegeben** ein Gast ohne aktuell zugewiesenen Raum und ein Raum existieren,

**Wenn** Rezeption diesem Gast im Rahmen eines Check-ins diesen Raum
zuweist,

**Dann**
- ist der Raum dem Gast zugewiesen,
- wird der Raum als belegt (Occupied) geführt,
- wird das Check-in-Datum beim Gast gespeichert.

**Offene Bezüge:**
- OFFEN (`testbasis.md`, Abschnitt 9): Die Zeitzone, in der das
  Check-in-Datum geführt wird, ist nicht spezifiziert.

---

## AC-CHAT-010: Gast auschecken

**Anforderung:**
Rezeption kann die Raumzuweisung eines Gastes entfernen, den Raum als in
Reinigung befindlich markieren und das Check-out-Datum speichern; der Raum
darf erst nach abgeschlossener Reinigung wieder als verfügbar markiert
werden.

**Quelle:**
- `specs/basis_spec.md`, Abschnitt „Check-Out" (Zeilen 95-98: „Remove room
  assignment", „Mark room as cleaning", „Store check-out date", „Mark the
  room as available only after cleaning is complete")

**Gegeben** ein Gast mit zugewiesenem Raum existiert,

**Wenn** Rezeption diesen Gast auscheckt,

**Dann**
- wird die Raumzuweisung des Gastes entfernt,
- wird der Raum unmittelbar danach als in Reinigung befindlich (Cleaning)
  geführt, nicht als verfügbar (Available),
- wird das Check-out-Datum beim Gast gespeichert.

**Offene Bezüge:**
- OFFEN (`testbasis.md`, Abschnitt 9): Die Zeitzone, in der das
  Check-out-Datum geführt wird, ist nicht spezifiziert.

---

## AC-CHAT-011: Nachricht an ein Zimmer senden

**Anforderung:**
Rezeption kann eine Nachricht erstellen, einen Zielraum auswählen, einen
Text eingeben und die Nachricht senden. Die Nachricht enthält dabei eine
eindeutige ID, den Sender, den Zielraum, den Inhalt, einen
Erstellungszeitstempel und den aktuellen Status.

**Quelle:**
- `specs/chat_feature_spec.md`, Abschnitt „Sending Messages" (Zeilen 29-32:
  „Create a message", „Select a target room", „Enter a message text", „Send
  the message"), User Story 1 (Zeilen 87-93), Abschnitt „Message Metadata"
  (Zeilen 76-81), Abschnitt „Message Status" (Zeilen 64-66: mögliche Werte
  sent/delivered/read)

**Gegeben** ein Zielraum existiert,

**Wenn** Rezeption an diesen Raum eine Nachricht mit Sender und Inhalt
sendet,

**Dann** wird die Nachricht gespeichert mit einer eindeutigen ID, dem
angegebenen Sender, dem Zielraum, dem angegebenen Inhalt, einem
Erstellungszeitstempel und dem Status „sent".

**Offene Bezüge:**
- OFFEN (`testbasis.md`, Abschnitt 9): Ob eine Nachricht auch an einen Raum
  ohne aktuell zugeordneten Gast gesendet werden darf, ist nicht
  spezifiziert.

---

## AC-CHAT-012: Alle Nachrichten auflisten (Rezeption)

**Anforderung:**
Rezeption kann alle Nachrichten ansehen.

**Quelle:**
- `specs/chat_feature_spec.md`, Abschnitt „Viewing Messages" (Zeile 40:
  „View all messages")

**Gegeben** eine oder mehrere Nachrichten sind im System vorhanden,

**Wenn** Rezeption die Liste aller Nachrichten abruft,

**Dann** werden alle vorhandenen Nachrichten in der Liste angezeigt.

**Offene Bezüge:**
- Keine

---

## AC-CHAT-013: Nachrichten nach Raum filtern (Rezeption)

**Anforderung:**
Rezeption kann Nachrichten nach Raum filtern.

**Quelle:**
- `specs/chat_feature_spec.md`, Abschnitt „Viewing Messages" (Zeile 41:
  „Filter messages by room")

**Gegeben** Nachrichten für mehrere unterschiedliche Räume sind vorhanden,

**Wenn** Rezeption die Nachrichtenliste nach einem bestimmten Raum
filtert,

**Dann** werden nur die diesem Raum zugeordneten Nachrichten in der Liste
angezeigt.

**Offene Bezüge:**
- Keine

---

## AC-CHAT-014: Nachrichtendetails ansehen (Rezeption)

**Anforderung:**
Rezeption kann die Details einer einzelnen Nachricht ansehen.

**Quelle:**
- `specs/chat_feature_spec.md`, Abschnitt „Viewing Messages" (Zeile 42:
  „View message details"), Abschnitt „Message Metadata" (Zeilen 76-81)

**Gegeben** eine Nachricht existiert,

**Wenn** Rezeption die Details dieser Nachricht abruft,

**Dann** werden eindeutige ID, Sender, Zielraum, Inhalt,
Erstellungszeitstempel und aktueller Status der Nachricht angezeigt.

**Offene Bezüge:**
- Keine

---

## AC-CHAT-015: Sichtbarkeit des Nachrichtenstatus

**Anforderung:**
Der Status einer Nachricht ist beim Anzeigen sichtbar, sodass Rezeption
erkennen kann, ob eine Nachricht gelesen wurde.

**Quelle:**
- `specs/chat_feature_spec.md`, Abschnitt „Message Status" (Zeile 68: „The
  status shall be visible when viewing messages"), User Story 3 (Zeilen
  107-113: „I want to see whether a message was read")

**Gegeben** eine Nachricht mit einem der Status sent, delivered oder read
existiert,

**Wenn** Rezeption diese Nachricht ansieht,

**Dann** wird der aktuelle Status der Nachricht angezeigt.

**Offene Bezüge:**
- OFFEN (`testbasis.md`, Abschnitt 9): Die fachliche Bedeutung des Status
  „delivered" (automatisch beim Abruf vs. tatsächlich wahrgenommen) ist
  nicht spezifiziert.

---

## AC-CHAT-016: Nachrichten des eigenen Raums ansehen (Gast)

**Anforderung:**
Ein Gast kann die seinem Raum zugeordneten Nachrichten ansehen.

**Quelle:**
- `specs/chat_feature_spec.md`, Abschnitt „Viewing Messages" (Zeile 46:
  „View messages assigned to their room"), User Story 2 (Zeilen 97-103)

**Gegeben** einem Raum sind eine oder mehrere Nachrichten zugeordnet,

**Wenn** der Gast dieses Raums die Nachrichten seines Raums abruft,

**Dann** werden ihm die diesem Raum zugeordneten Nachrichten angezeigt.

**Offene Bezüge:**
- Keine

---

## AC-CHAT-017: Nachrichtenhistorie bleibt nach Neustart erhalten

**Anforderung:**
Nachrichten werden dauerhaft gespeichert und bleiben nach einem Neustart
der Anwendung verfügbar.

**Quelle:**
- `specs/chat_feature_spec.md`, Abschnitt „Message History" (Zeilen 52-54:
  „The system shall store messages permanently", „Stored messages shall
  remain available after application restart")

**Gegeben** eine Nachricht wurde gesendet und gespeichert,

**Wenn** die Anwendung neu gestartet wird,

**Dann** ist die Nachricht weiterhin unverändert vorhanden und abrufbar.

**Offene Bezüge:**
- Keine

---

## Nicht ableitbare Akzeptanzkriterien

Die folgenden Verhaltensweisen sind in der laufenden Anwendung beobachtbar,
aber nicht aus einer bestätigten fachlichen Anforderung ableitbar. Sie
werden hier bewusst nicht als Akzeptanzkriterium geführt.

1. **Wer/wann den Nachrichtenstatus auf „delivered" bzw. „read" setzt.**
   `specs/chat_feature_spec.md` benennt „Read-status handling" ausdrücklich
   als offene Frage (Zeile 151, Abschnitt „Open Questions"). Die aktuelle
   Umsetzung (automatisches „delivered" beim Laden der Gastsicht, „read"
   als explizite Aktion) ist eine dokumentierte Implementierungsentscheidung,
   keine bestätigte Anforderung.
   → Bezug: `testbasis.md`, Abschnitt 6 (Rahmenbedingung „Automatische
   Status-Transition") und Abschnitt 9 (OFFEN: Bedeutung von „delivered").

2. **Senden von Nachrichten durch den Gast.**
   `specs/chat_feature_spec.md` beschreibt für Gäste in User Story 2 und im
   Abschnitt „Viewing Messages" ausschließlich das **Ansehen** von
   Nachrichten, nicht das Senden. Die implementierte Sendefunktion für
   Gäste ist laut `docs/decisions.md` (Decision 008) eine bewusste,
   dokumentierte Erweiterung über den Spezifikationswortlaut hinaus, keine
   bestätigte fachliche Anforderung.
   → Bezug: `testbasis.md`, Abschnitt 6 (Rahmenbedingung „Guest-Nachrichten
   senden").

3. **Konkreter Mechanismus der Gast-Identifikation ohne Authentifizierung.**
   Dass ein Gast ohne Login Zugriff auf „seine" Nachrichten hat, ist durch
   User Story 2 fachlich gedeckt (siehe AC-CHAT-016). Der konkrete
   Zugriffsweg (Raum-ID als alleiniges Zugriffsmerkmal) ist jedoch nicht
   spezifiziert — `specs/chat_feature_spec.md` benennt „Technical
   implementation details" ausdrücklich als offene Frage (Zeile 149).
   → Bezug: `testbasis.md`, Abschnitt 6 (Rahmenbedingung „Keine
   Authentifizierung").

4. **Einschränkung, welche Raumstatus-Übergänge zulässig sind** (z. B. dass
   ein belegter Raum ausschließlich zu „Cleaning" wechseln darf).
   `specs/basis_spec.md` fordert nur allgemein „Change room status" (Zeile
   58) ohne Übergangsregeln zu benennen; die konkrete Einschränkung ist
   eine Implementierungsentscheidung.
   → Bezug: `testbasis.md`, Abschnitt 6 (Rahmenbedingung
   „Raumstatus-Übergangsregel").

5. **Vorbedingungen für Check-in/Check-out**, unter denen die Anwendung
   eine Aktion verweigert (Gast hat bereits einen Raum; Raum ist nicht
   verfügbar; Gast hat aktuell keinen Raum beim Check-out). Diese konkreten
   Vorbedingungen sind nicht wörtlich in `specs/basis_spec.md` benannt.
   → Bezug: `testbasis.md`, Abschnitt 6 (Rahmenbedingung
   „Check-in-/Check-out-Vorbedingungen").

6. **Einschränkung beim Löschen eines Gastes mit zugewiesenem Raum.**
   `specs/basis_spec.md` fordert nur allgemein „Delete guests" (Zeile 77)
   ohne diese Einschränkung zu benennen.
   → Bezug: `testbasis.md`, Abschnitt 6 (Rahmenbedingung „Löschen eines
   Gasts").

7. **Vorhandensein automatisierter Tests als Projektzustand.** Beide
   Spezifikationen fordern wörtlich automatisierte Tests als
   Qualitätsanforderung; dies ist jedoch eine Projekt-/Prozessanforderung,
   kein als Gegeben–Wenn–Dann beobachtbares Verhalten der laufenden
   Anwendung, und steht zudem im Widerspruch zum aktuellen
   Repository-Zustand (0 Tests vorhanden).
   → Bezug: `testbasis.md`, Abschnitt 10 (Widerspruch „Automatisierte
   Tests gefordert, aber nicht vorhanden").

---

**Ende der Akzeptanzkriterien**
