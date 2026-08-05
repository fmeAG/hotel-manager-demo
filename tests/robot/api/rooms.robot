*** Settings ***
Documentation       Room management — API level.
...                  Source: docs/testing/testfaelle.md (TC-CHAT-001..003)

Resource            ../resources/api.resource

Test Tags           api    rooms


*** Variables ***
${ROOM_101}          1
${ROOM_202}          4


*** Test Cases ***
TC-CHAT-001 Alle Raeume auflisten
    [Documentation]    AC-CHAT-001 / R-CHAT-001
    ...    Gegeben mehrere Raeume existieren, wenn die Raumliste abgerufen wird,
    ...    dann sind alle vorhandenen Raeume enthalten.
    [Tags]    TC-CHAT-001    AC-CHAT-001    R-CHAT-001
    ${rooms}=    List Rooms
    ${numbers}=    Create List
    FOR    ${room}    IN    @{rooms}
        Append To List    ${numbers}    ${room}[number]
    END
    List Should Contain Value    ${numbers}    101
    List Should Contain Value    ${numbers}    102
    List Should Contain Value    ${numbers}    201
    List Should Contain Value    ${numbers}    202
    List Should Contain Value    ${numbers}    301

TC-CHAT-002 Details eines einzelnen Raums ansehen
    [Documentation]    AC-CHAT-002 / R-CHAT-001
    ...    Gegeben Raum 101 existiert, wenn seine Details abgerufen werden,
    ...    dann werden Raumnummer, Kategorie und Belegungsstatus angezeigt.
    [Tags]    TC-CHAT-002    AC-CHAT-002    R-CHAT-001
    ${room}=    Get Room    ${ROOM_101}
    Should Be Equal As Strings    ${room}[number]    101
    Should Be Equal As Strings    ${room}[category]    Single
    Should Not Be Empty    ${room}[status]

TC-CHAT-003 Raumstatus aendern
    [Documentation]    AC-CHAT-003 / R-CHAT-002
    ...    Gegeben Raum 202 hat Status "cleaning", wenn der Status auf
    ...    "available" geaendert wird, dann wird der neue Status beim Abruf
    ...    angezeigt.
    [Tags]    TC-CHAT-003    AC-CHAT-003    R-CHAT-002
    [Setup]    Ensure Room Status    ${ROOM_202}    cleaning
    [Teardown]    Ensure Room Status    ${ROOM_202}    cleaning
    Set Room Status    ${ROOM_202}    available
    Room Status Should Be    ${ROOM_202}    available
