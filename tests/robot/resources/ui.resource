*** Settings ***
Documentation       Low-level Browser Library keywords for the reception and
...                  guest-facing message pages. Selectors are copied from
...                  static/messages.html and static/guest_messages.html.

Library              Browser


*** Variables ***
${UI_BASE_URL}        http://127.0.0.1:8001
${HEADLESS}           ${TRUE}
${SLOWMO}             0


*** Keywords ***
Open Browser For UI Tests
    [Documentation]    Suite-level setup: one browser, one context with the
    ...    application's base URL, reused across the suite's tests.
    ...    ${HEADLESS} and ${SLOWMO} are overridable via --variable for
    ...    interactive/demo runs (e.g. --variable HEADLESS:False
    ...    --variable SLOWMO:1s).
    New Browser    chromium    headless=${HEADLESS}    slowMo=${SLOWMO}
    New Context    baseURL=${UI_BASE_URL}

Close Browser For UI Tests
    [Documentation]    Suite-level teardown counterpart to `Open Browser For UI Tests`.
    Close Browser

Open Reception Messages Page
    [Documentation]    Opens the reception message list (static/messages.html).
    New Page    /messages.html
    Wait For Elements State    id=messages-body    attached

Filter Reception Messages By Room
    [Documentation]    Uses the room filter dropdown on the reception page.
    ...    ${room_number} is the visible room number label (e.g. "101"),
    ...    matching the option text rendered by static/js/messages.js.
    [Arguments]    ${room_number}
    Select Options By    id=filter-room    label    ${room_number}

Reception Message List Should Contain
    [Documentation]    Asserts the reception message table's rendered text
    ...    contains the given substring.
    [Arguments]    ${expected_text}
    Get Text    id=messages-body    contains    ${expected_text}

Open Guest Chat For Room
    [Documentation]    Opens the guest-facing chat for a given room id, using the
    ...    unauthenticated ?room_id= URL (Decision 008).
    [Arguments]    ${room_id}
    New Page    /guest_messages.html?room_id=${room_id}
    Wait For Elements State    id=history-panel    visible

Guest Message List Should Contain
    [Documentation]    Asserts the guest chat message table's rendered text
    ...    contains the given substring.
    [Arguments]    ${expected_text}
    Get Text    id=messages-body    contains    ${expected_text}

Guest Message List Should Not Contain
    [Documentation]    Asserts the guest chat message table's rendered text does
    ...    not contain the given substring.
    [Arguments]    ${unexpected_text}
    Get Text    id=messages-body    not contains    ${unexpected_text}
