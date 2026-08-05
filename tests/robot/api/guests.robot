*** Settings ***
Documentation       Guest management — API level.
...                  Source: docs/testing/testfaelle.md (TC-CHAT-004..008)

Resource            ../resources/api.resource

Test Tags           api    guests


*** Test Cases ***
TC-CHAT-004 Gast anlegen
    [Documentation]    AC-CHAT-004 / R-CHAT-005
    ...    Gegeben Vorname und Nachname sind angegeben, wenn ein neuer Gast
    ...    angelegt wird, dann ist er mit diesen Namen abrufbar.
    [Tags]    TC-CHAT-004    AC-CHAT-004    R-CHAT-005
    ${created}=    Create Guest    Jörg    Müller
    [Teardown]    Delete Guest If Exists    ${created}[id]
    ${guest}=    Get Guest    ${created}[id]
    Should Be Equal As Strings    ${guest}[first_name]    Jörg
    Should Be Equal As Strings    ${guest}[last_name]    Müller

TC-CHAT-005 Gaesteliste abrufen
    [Documentation]    AC-CHAT-005 / R-CHAT-004
    ...    Gegeben mindestens ein Gast existiert, wenn die Gaesteliste
    ...    abgerufen wird, dann ist dieser Gast enthalten.
    [Tags]    TC-CHAT-005    AC-CHAT-005    R-CHAT-004
    ${created}=    Create Guest    Test    Gast005
    [Teardown]    Delete Guest If Exists    ${created}[id]
    ${guests}=    List Guests
    ${ids}=    Create List
    FOR    ${guest}    IN    @{guests}
        Append To List    ${ids}    ${guest}[id]
    END
    List Should Contain Value    ${ids}    ${created}[id]

TC-CHAT-006 Details eines einzelnen Gastes ansehen
    [Documentation]    AC-CHAT-006 / R-CHAT-004
    ...    Gegeben ein Gast mit Vorname und Nachname existiert, wenn seine
    ...    Details abgerufen werden, dann werden Vorname, Nachname,
    ...    zugewiesener Raum, Check-in- und Check-out-Datum angezeigt.
    [Tags]    TC-CHAT-006    AC-CHAT-006    R-CHAT-004
    ${created}=    Create Guest    Anna    Schmidt
    [Teardown]    Delete Guest If Exists    ${created}[id]
    ${guest}=    Get Guest    ${created}[id]
    Should Be Equal As Strings    ${guest}[first_name]    Anna
    Should Be Equal As Strings    ${guest}[last_name]    Schmidt
    Dictionary Should Contain Key    ${guest}    room_id
    Dictionary Should Contain Key    ${guest}    check_in_date
    Dictionary Should Contain Key    ${guest}    check_out_date

TC-CHAT-007 Gast bearbeiten
    [Documentation]    AC-CHAT-007 / R-CHAT-006
    ...    Gegeben ein Gast existiert, wenn sein Nachname geaendert wird,
    ...    dann wird der geaenderte Nachname beim erneuten Abruf angezeigt.
    [Tags]    TC-CHAT-007    AC-CHAT-007    R-CHAT-006
    ${created}=    Create Guest    Anna    Schmidt
    [Teardown]    Delete Guest If Exists    ${created}[id]
    Update Guest    ${created}[id]    Anna    Schmidt-Weber
    ${guest}=    Get Guest    ${created}[id]
    Should Be Equal As Strings    ${guest}[last_name]    Schmidt-Weber

TC-CHAT-008 Gast loeschen
    [Documentation]    AC-CHAT-008 / R-CHAT-007
    ...    Gegeben ein Gast existiert, wenn er geloescht wird, dann ist er
    ...    danach nicht mehr abrufbar.
    [Tags]    TC-CHAT-008    AC-CHAT-008    R-CHAT-007
    ${created}=    Create Guest    Test    Gast008
    Delete Guest    ${created}[id]
    GET    ${BASE_URL}/api/guests/${created}[id]    expected_status=404
