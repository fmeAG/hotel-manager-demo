*** Settings ***
Documentation       Low-level API keywords for the Hotel Management application.
...                  Wraps RequestsLibrary calls; test suites use these keywords,
...                  never RequestsLibrary directly.

Library              RequestsLibrary
Library              Collections


*** Variables ***
${BASE_URL}           http://127.0.0.1:8001


*** Keywords ***
List Rooms
    [Documentation]    Returns all rooms as a list of dictionaries (AC-CHAT-001).
    ${response}=    GET    ${BASE_URL}/api/rooms    expected_status=200
    RETURN    ${response.json()}

Get Room
    [Documentation]    Returns the room resource as a dictionary.
    [Arguments]    ${room_id}
    ${response}=    GET    ${BASE_URL}/api/rooms/${room_id}    expected_status=200
    RETURN    ${response.json()}

Set Room Status
    [Documentation]    Sends the status-change request as-is; does not work around
    ...    the application's transition rule. Use `Ensure Room Status` in test
    ...    setup when the current status is unknown.
    [Arguments]    ${room_id}    ${status}
    ${body}=    Create Dictionary    status=${status}
    ${response}=    PATCH    ${BASE_URL}/api/rooms/${room_id}/status    json=${body}    expected_status=200
    RETURN    ${response.json()}

Ensure Room Status
    [Documentation]    Test-setup helper: brings a room into the required status
    ...    regardless of its current status, using only the confirmed status
    ...    transition rule (AC-CHAT-003 / Decision 009: an occupied room may
    ...    only move to "cleaning" directly). This keyword establishes a
    ...    precondition; it is not itself an assertion of expected behaviour.
    [Arguments]    ${room_id}    ${status}
    ${room}=    Get Room    ${room_id}
    IF    '${room}[status]' == 'occupied' and '${status}' != 'cleaning'
        Set Room Status    ${room_id}    cleaning
    END
    Set Room Status    ${room_id}    ${status}

Room Status Should Be
    [Documentation]    Asserts a room's current status (AC-CHAT-002 / AC-CHAT-003).
    [Arguments]    ${room_id}    ${expected_status}
    ${room}=    Get Room    ${room_id}
    Should Be Equal As Strings    ${room}[status]    ${expected_status}

List Guests
    [Documentation]    Returns all guests as a list of dictionaries (AC-CHAT-005).
    ${response}=    GET    ${BASE_URL}/api/guests    expected_status=200
    RETURN    ${response.json()}

Create Guest
    [Documentation]    Creates a guest (AC-CHAT-004) and returns the created resource.
    [Arguments]    ${first_name}    ${last_name}
    ${body}=    Create Dictionary    first_name=${first_name}    last_name=${last_name}
    ${response}=    POST    ${BASE_URL}/api/guests    json=${body}    expected_status=201
    RETURN    ${response.json()}

Get Guest
    [Documentation]    Returns a guest resource as a dictionary (AC-CHAT-006).
    [Arguments]    ${guest_id}
    ${response}=    GET    ${BASE_URL}/api/guests/${guest_id}    expected_status=200
    RETURN    ${response.json()}

Update Guest
    [Documentation]    Updates a guest's first/last name (AC-CHAT-007).
    [Arguments]    ${guest_id}    ${first_name}    ${last_name}
    ${body}=    Create Dictionary    first_name=${first_name}    last_name=${last_name}
    ${response}=    PUT    ${BASE_URL}/api/guests/${guest_id}    json=${body}    expected_status=200
    RETURN    ${response.json()}

Delete Guest
    [Documentation]    Deletes a guest (AC-CHAT-008). Fails the test if the
    ...    deletion is rejected — use `Delete Guest If Exists` in teardown
    ...    instead when the guest may already be gone or absent.
    [Arguments]    ${guest_id}
    DELETE    ${BASE_URL}/api/guests/${guest_id}    expected_status=204

Delete Guest If Exists
    [Documentation]    Teardown helper: deletes a guest without failing the test
    ...    if the guest no longer exists or cannot be deleted (e.g. still
    ...    checked in). Keeps teardown from masking the test's real result.
    [Arguments]    ${guest_id}
    GET    ${BASE_URL}/api/guests/${guest_id}    expected_status=any
    DELETE    ${BASE_URL}/api/guests/${guest_id}    expected_status=any

Check In Guest
    [Documentation]    Checks a guest into a room (AC-CHAT-009).
    [Arguments]    ${guest_id}    ${room_id}
    ${body}=    Create Dictionary    room_id=${room_id}
    ${response}=    POST    ${BASE_URL}/api/guests/${guest_id}/checkin    json=${body}    expected_status=200
    RETURN    ${response.json()}

Check Out Guest
    [Documentation]    Checks a guest out (AC-CHAT-010).
    [Arguments]    ${guest_id}
    ${response}=    POST    ${BASE_URL}/api/guests/${guest_id}/checkout    expected_status=200
    RETURN    ${response.json()}

Send Message
    [Documentation]    Sends a message to a room (AC-CHAT-011) and returns the
    ...    created message resource.
    [Arguments]    ${room_id}    ${sender}    ${content}
    ${body}=    Create Dictionary    room_id=${room_id}    sender=${sender}    content=${content}
    ${response}=    POST    ${BASE_URL}/api/messages    json=${body}    expected_status=201
    RETURN    ${response.json()}

List Messages
    [Documentation]    Returns all messages, or the messages for a single room
    ...    when ${room_id} is given (AC-CHAT-012 / AC-CHAT-013).
    [Arguments]    ${room_id}=${NONE}
    IF    $room_id is None
        ${response}=    GET    ${BASE_URL}/api/messages    expected_status=200
    ELSE
        ${params}=    Create Dictionary    room_id=${room_id}
        ${response}=    GET    ${BASE_URL}/api/messages    params=${params}    expected_status=200
    END
    RETURN    ${response.json()}

Get Message
    [Documentation]    Returns a single message's details (AC-CHAT-014).
    [Arguments]    ${message_id}
    ${response}=    GET    ${BASE_URL}/api/messages/${message_id}    expected_status=200
    RETURN    ${response.json()}

Set Message Status
    [Documentation]    Advances a message's status via the application's existing
    ...    status-change function. Used as a test-setup helper in TC-CHAT-015;
    ...    the transition rule itself is not covered by a confirmed acceptance
    ...    criterion (see akzeptanzkriterien.md, "Nicht ableitbare
    ...    Akzeptanzkriterien", item 1) and is therefore never asserted on.
    [Arguments]    ${message_id}    ${status}
    ${body}=    Create Dictionary    status=${status}
    ${response}=    PATCH    ${BASE_URL}/api/messages/${message_id}/status    json=${body}    expected_status=200
    RETURN    ${response.json()}
