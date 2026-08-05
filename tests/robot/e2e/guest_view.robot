*** Settings ***
Documentation       Guest-facing chat view — E2E level.
...                  Source: docs/testing/testfaelle.md (TC-CHAT-016)

Resource            ../resources/api.resource
Resource            ../resources/ui.resource

Suite Setup         Open Browser For UI Tests
Suite Teardown      Close Browser For UI Tests
Test Teardown       Close Page

Test Tags           e2e    guest-view


*** Variables ***
${ROOM_101}          1
${ROOM_201}          3


*** Test Cases ***
TC-CHAT-016 Nachrichten des eigenen Raums ansehen (Gast)
    [Documentation]    AC-CHAT-016 / R-CHAT-011
    ...    Gegeben zwei Raeume mit je einer eigenen Nachricht existieren,
    ...    wenn die Gastsicht fuer einen der Raeume geoeffnet wird, dann wird
    ...    dessen Nachricht angezeigt, nicht aber die Nachricht des anderen
    ...    Raums.
    [Tags]    TC-CHAT-016    AC-CHAT-016    R-CHAT-011
    Send Message    ${ROOM_101}    Reception    Ihr Zimmer ist bereit.
    Send Message    ${ROOM_201}    Reception    Bitte melden Sie sich an der Rezeption.

    Open Guest Chat For Room    ${ROOM_101}
    Guest Message List Should Contain    Ihr Zimmer ist bereit.
    Guest Message List Should Not Contain    Bitte melden Sie sich an der Rezeption.
