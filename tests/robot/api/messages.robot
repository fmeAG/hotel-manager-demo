*** Settings ***
Documentation       Messaging (reception) — API level.
...                  Source: docs/testing/testfaelle.md (TC-CHAT-011..015, TC-CHAT-017)

Resource            ../resources/api.resource

Test Tags           api    messages


*** Variables ***
${ROOM_101}          1
${ROOM_102}          2
${ROOM_201}          3
${ROOM_202}          4
${ROOM_301}          5


*** Test Cases ***
TC-CHAT-011 Gueltige Nachricht an ein Zimmer senden (korrekte Zimmerzuordnung)
    [Documentation]    AC-CHAT-011 / R-CHAT-011
    ...    Gegeben zwei Zielraeume existieren, wenn je eine Nachricht an jeden
    ...    Raum gesendet wird, dann wird jede Nachricht vollstaendig mit
    ...    eindeutiger ID, Sender, Inhalt, Zeitstempel und Status "sent"
    ...    gespeichert und ist ausschliesslich ihrem eigenen Zielraum
    ...    zugeordnet.
    [Tags]    TC-CHAT-011    AC-CHAT-011    R-CHAT-011
    ${message_101}=    Send Message    ${ROOM_101}    Reception    Das Frühstück beginnt morgen um 07:00 Uhr.
    ${message_201}=    Send Message    ${ROOM_201}    Reception    Ihr Zimmer wird um 14 Uhr gereinigt.
    Should Not Be Equal    ${message_101}[id]    ${NONE}
    Should Be Equal As Strings    ${message_101}[sender]    Reception
    Should Be Equal As Strings    ${message_101}[content]    Das Frühstück beginnt morgen um 07:00 Uhr.
    Should Not Be Empty    ${message_101}[created_at]
    Should Be Equal As Strings    ${message_101}[status]    sent

    ${room_101_messages}=    List Messages    ${ROOM_101}
    ${room_201_messages}=    List Messages    ${ROOM_201}
    ${room_101_ids}=    Create List
    FOR    ${message}    IN    @{room_101_messages}
        Append To List    ${room_101_ids}    ${message}[id]
    END
    ${room_201_ids}=    Create List
    FOR    ${message}    IN    @{room_201_messages}
        Append To List    ${room_201_ids}    ${message}[id]
    END
    List Should Contain Value    ${room_101_ids}    ${message_101}[id]
    List Should Contain Value    ${room_201_ids}    ${message_201}[id]
    List Should Not Contain Value    ${room_201_ids}    ${message_101}[id]
    List Should Not Contain Value    ${room_101_ids}    ${message_201}[id]

TC-CHAT-012 Alle Nachrichten auflisten
    [Documentation]    AC-CHAT-012 / R-CHAT-013
    ...    Gegeben mindestens eine Nachricht existiert, wenn die Liste aller
    ...    Nachrichten abgerufen wird, dann ist diese Nachricht enthalten.
    [Tags]    TC-CHAT-012    AC-CHAT-012    R-CHAT-013
    ${sent}=    Send Message    ${ROOM_102}    Reception    Testnachricht für TC-CHAT-012.
    ${all_messages}=    List Messages
    ${ids}=    Create List
    FOR    ${message}    IN    @{all_messages}
        Append To List    ${ids}    ${message}[id]
    END
    List Should Contain Value    ${ids}    ${sent}[id]

TC-CHAT-013 Nachrichten nach Raum filtern
    [Documentation]    AC-CHAT-013 / R-CHAT-014
    ...    Gegeben Nachrichten fuer zwei unterschiedliche Raeume existieren,
    ...    wenn die Nachrichtenliste nach einem der Raeume gefiltert wird,
    ...    dann enthaelt sie nur dessen Nachricht.
    [Tags]    TC-CHAT-013    AC-CHAT-013    R-CHAT-014
    ${message_a}=    Send Message    ${ROOM_102}    Reception    Ihr Taxi wartet in 10 Minuten.
    ${message_b}=    Send Message    ${ROOM_202}    Reception    Der Zimmerservice ist heute bis 22 Uhr erreichbar.
    ${filtered}=    List Messages    ${ROOM_102}
    ${ids}=    Create List
    FOR    ${message}    IN    @{filtered}
        Append To List    ${ids}    ${message}[id]
    END
    List Should Contain Value    ${ids}    ${message_a}[id]
    List Should Not Contain Value    ${ids}    ${message_b}[id]

TC-CHAT-014 Details einer einzelnen Nachricht ansehen
    [Documentation]    AC-CHAT-014 / R-CHAT-012
    ...    Gegeben eine Nachricht existiert, wenn ihre Details abgerufen
    ...    werden, dann werden ID, Sender, Zielraum, Inhalt, Zeitstempel und
    ...    Status angezeigt.
    [Tags]    TC-CHAT-014    AC-CHAT-014    R-CHAT-012
    ${sent}=    Send Message    ${ROOM_301}    Reception    Herzlich willkommen im Hotel!
    ${message}=    Get Message    ${sent}[id]
    Should Be Equal As Strings    ${message}[sender]    Reception
    Should Be Equal As Integers    ${message}[room_id]    ${ROOM_301}
    Should Be Equal As Strings    ${message}[content]    Herzlich willkommen im Hotel!
    Should Not Be Empty    ${message}[created_at]
    Should Not Be Empty    ${message}[status]

TC-CHAT-015 Sichtbarkeit des Nachrichtenstatus
    [Documentation]    AC-CHAT-015 / R-CHAT-015
    ...    Gegeben eine Nachricht existiert, wenn ihr Status abgerufen wird,
    ...    dann entspricht er dem zuletzt gesetzten Status.
    ...    Hinweis: Der Statuswechsel in Schritt 2 dient nur der
    ...    Vorbedingungs-Herstellung (siehe akzeptanzkriterien.md, "Nicht
    ...    ableitbare Akzeptanzkriterien", Punkt 1) und ist selbst keine
    ...    geprüfte Aussage dieses Testfalls.
    [Tags]    TC-CHAT-015    AC-CHAT-015    R-CHAT-015
    ${sent}=    Send Message    ${ROOM_101}    Reception    Ihr Anschlussflug wurde bestätigt.
    ${after_send}=    Get Message    ${sent}[id]
    Should Be Equal As Strings    ${after_send}[status]    sent

    Set Message Status    ${sent}[id]    delivered
    ${after_change}=    Get Message    ${sent}[id]
    Should Be Equal As Strings    ${after_change}[status]    delivered

TC-CHAT-017 Nachrichtenhistorie bleibt nach Neustart der Anwendung erhalten
    [Documentation]    AC-CHAT-017 / R-CHAT-019
    ...    Bewusst manuell: erfordert einen Neustart des Anwendungsprozesses
    ...    und ist damit nicht Teil eines normalen automatisierten
    ...    Testlaufs (siehe testfaelle.md, TC-CHAT-017).
    [Tags]    TC-CHAT-017    AC-CHAT-017    R-CHAT-019    manual
    Skip    Manuell: erfordert Neustart des Anwendungsprozesses (siehe testfaelle.md, TC-CHAT-017).
