*** Settings ***
Documentation       Check-in / check-out — API level.
...                  Source: docs/testing/testfaelle.md (TC-CHAT-009, TC-CHAT-010, TC-CHAT-018)

Resource            ../resources/api.resource

Test Tags           api    checkinout


*** Variables ***
${ROOM_101}          1


*** Test Cases ***
TC-CHAT-009 Gast einchecken
    [Documentation]    AC-CHAT-009 / R-CHAT-008
    ...    Gegeben ein Gast ohne Raum und ein verfuegbarer Raum existieren,
    ...    wenn der Gast eingecheckt wird, dann ist ihm der Raum zugewiesen,
    ...    der Raum gilt als belegt und ein Check-in-Datum ist gespeichert.
    [Tags]    TC-CHAT-009    AC-CHAT-009    R-CHAT-008
    [Setup]    Ensure Room Status    ${ROOM_101}    available
    ${guest}=    Create Guest    Testgast    Checkin009
    [Teardown]    Clean Up Checked In Guest    ${guest}[id]    ${ROOM_101}
    Check In Guest    ${guest}[id]    ${ROOM_101}
    ${reloaded_guest}=    Get Guest    ${guest}[id]
    Should Be Equal As Integers    ${reloaded_guest}[room_id]    ${ROOM_101}
    Should Not Be Equal    ${reloaded_guest}[check_in_date]    ${NONE}
    Room Status Should Be    ${ROOM_101}    occupied

TC-CHAT-010 Gast auschecken
    [Documentation]    AC-CHAT-010 / R-CHAT-010
    ...    Gegeben ein Gast mit zugewiesenem Raum existiert, wenn er
    ...    ausgecheckt wird, dann ist die Raumzuweisung entfernt, der Raum
    ...    gilt als in Reinigung (nicht verfuegbar) und ein
    ...    Check-out-Datum ist gespeichert.
    [Tags]    TC-CHAT-010    AC-CHAT-010    R-CHAT-010
    Ensure Room Status    ${ROOM_101}    available
    ${guest}=    Create Guest    Testgast    Checkout010
    Check In Guest    ${guest}[id]    ${ROOM_101}
    [Teardown]    Clean Up Guest And Reset Room    ${guest}[id]    ${ROOM_101}
    Check Out Guest    ${guest}[id]
    ${reloaded_guest}=    Get Guest    ${guest}[id]
    Should Be Equal    ${reloaded_guest}[room_id]    ${NONE}
    Should Not Be Equal    ${reloaded_guest}[check_out_date]    ${NONE}
    Room Status Should Be    ${ROOM_101}    cleaning

TC-CHAT-018 Gleichzeitiger Check-in mehrerer Gaeste auf denselben Raum
    [Documentation]    R-CHAT-009 (Nebenlaeufigkeit)
    ...    Bewusst manuell: kein bestaetigtes Akzeptanzkriterium deckt ein
    ...    erwartetes Ergebnis fuer den Konfliktfall ab (siehe
    ...    risikoanalyse.md, R-CHAT-009, und testfaelle.md, TC-CHAT-018).
    ...    Dieser Testfall bleibt bewusst unautomatisiert und wird
    ...    uebersprungen, statt stillschweigend automatisiert zu werden.
    [Tags]    TC-CHAT-018    AC-CHAT-009    R-CHAT-009    manual
    Skip    Manuell: Nebenlaeufigkeitstest ohne bestaetigtes erwartetes Ergebnis (siehe testfaelle.md, TC-CHAT-018).


*** Keywords ***
Clean Up Checked In Guest
    [Documentation]    Teardown for TC-CHAT-009: checks the guest out again so it
    ...    can be deleted, then restores the room to "available".
    [Arguments]    ${guest_id}    ${room_id}
    Check Out Guest    ${guest_id}
    Delete Guest If Exists    ${guest_id}
    Ensure Room Status    ${room_id}    available

Clean Up Guest And Reset Room
    [Documentation]    Teardown for TC-CHAT-010: the guest is already checked out
    ...    by the test itself (or left checked in if the test failed before
    ...    that step); either way, ensure both are cleaned up.
    [Arguments]    ${guest_id}    ${room_id}
    ${guest}=    Get Guest    ${guest_id}
    IF    $guest['room_id'] is not None
        Check Out Guest    ${guest_id}
    END
    Delete Guest If Exists    ${guest_id}
    Ensure Room Status    ${room_id}    available
