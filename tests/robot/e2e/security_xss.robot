*** Settings ***
Documentation       Message content/sender rendering — E2E level.
...                  Source: docs/testing/testfaelle.md (TC-CHAT-019..021)
...
...                  These three test cases are expected to currently FAIL.
...                  docs/testing/analyse_20260804.md (5.1) and
...                  docs/testing/risikoanalyse.md (R-CHAT-017) document, via
...                  direct code review of static/js/messages.js and
...                  static/js/guest_messages.js, that message content and
...                  sender values are inserted through element.innerHTML
...                  without escaping. A failure here is evidence of that
...                  known product defect, not a test-authoring error — see
...                  testfaelle.md, TC-CHAT-019, "Hinweis zur Ableitung", for
...                  why the expected result is an interpretation of
...                  AC-CHAT-014 / AC-CHAT-016 that still needs explicit
...                  fachliche confirmation.

Resource            ../resources/api.resource
Resource            ../resources/ui.resource

Suite Setup         Open Browser For UI Tests
Suite Teardown      Close Browser For UI Tests
Test Teardown       Close Page

Test Tags           e2e    security


*** Variables ***
${ROOM_101}          1
${ROOM_101_NUMBER}    101
${ROOM_102}          2
${ROOM_102_NUMBER}    102
${ROOM_201}          3
${PAYLOAD}           <b>Test</b>


*** Test Cases ***
TC-CHAT-019 Nachrichteninhalt wird nicht als aktiver Code ausgefuehrt (Rezeptionssicht)
    [Documentation]    AC-CHAT-014 / R-CHAT-017
    ...    Gegeben eine Nachricht mit HTML-Markup als Inhalt wurde an einen
    ...    Raum gesendet, wenn die Rezeptionsansicht diesen Raum anzeigt,
    ...    dann wird der Inhalt als Text angezeigt, nicht als aktives Markup
    ...    interpretiert.
    [Tags]    TC-CHAT-019    AC-CHAT-014    R-CHAT-017    known-defect
    Send Message    ${ROOM_101}    Reception    ${PAYLOAD}
    Open Reception Messages Page
    Filter Reception Messages By Room    ${ROOM_101_NUMBER}
    Reception Message List Should Contain    ${PAYLOAD}

TC-CHAT-020 Sender-Feld wird nicht als aktiver Code ausgefuehrt (Rezeptionssicht)
    [Documentation]    AC-CHAT-011 / AC-CHAT-014 / R-CHAT-017
    ...    Gegeben eine Nachricht mit HTML-Markup als Sender-Wert wurde an
    ...    einen Raum gesendet, wenn die Rezeptionsansicht diesen Raum
    ...    anzeigt, dann wird der Sender-Wert als Text angezeigt, nicht als
    ...    aktives Markup interpretiert.
    [Tags]    TC-CHAT-020    AC-CHAT-014    R-CHAT-017    known-defect
    Send Message    ${ROOM_102}    ${PAYLOAD}    Testnachricht
    Open Reception Messages Page
    Filter Reception Messages By Room    ${ROOM_102_NUMBER}
    Reception Message List Should Contain    ${PAYLOAD}

TC-CHAT-021 Nachrichteninhalt wird nicht als aktiver Code ausgefuehrt (Gastsicht)
    [Documentation]    AC-CHAT-016 / R-CHAT-017
    ...    Gegeben eine Nachricht mit HTML-Markup als Inhalt wurde an einen
    ...    Raum gesendet, wenn die Gastsicht dieses Raums geoeffnet wird,
    ...    dann wird der Inhalt als Text angezeigt, nicht als aktives Markup
    ...    interpretiert.
    [Tags]    TC-CHAT-021    AC-CHAT-016    R-CHAT-017    known-defect
    Send Message    ${ROOM_201}    Reception    ${PAYLOAD}
    Open Guest Chat For Room    ${ROOM_201}
    Guest Message List Should Contain    ${PAYLOAD}
