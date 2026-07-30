const GUEST_SENDER_PREFIX = "Guest (";

const params = new URLSearchParams(window.location.search);
const roomId = Number(params.get("room_id"));
const hasRoomId = Number.isInteger(roomId) && roomId > 0;
let currentRoom = null;

function isFromGuest(sender) {
  return sender.startsWith(GUEST_SENDER_PREFIX);
}

function setChatVisible(isVisible) {
  document.getElementById("room-selection").hidden = isVisible;
  document.getElementById("send-panel").hidden = !isVisible;
  document.getElementById("history-panel").hidden = !isVisible;
}

async function loadRoomOptions() {
  const res = await fetch("/api/rooms");
  if (!res.ok) return;

  const roomSelect = document.getElementById("room-select");
  const rooms = await res.json();
  for (const room of rooms) {
    const option = document.createElement("option");
    option.value = room.id;
    option.textContent = `Room ${room.number}`;
    roomSelect.appendChild(option);
  }
}

async function loadRoomLabel() {
  const res = await fetch(`/api/rooms/${roomId}`);
  if (!res.ok) {
    document.getElementById("room-label").textContent = "Unknown room";
    return null;
  }
  currentRoom = await res.json();
  document.getElementById("room-label").textContent = `Room ${currentRoom.number}`;
  return currentRoom;
}

async function markDelivered(messages) {
  const toDeliver = messages.filter(m => m.status === "sent" && !isFromGuest(m.sender));
  for (const m of toDeliver) {
    await fetch(`/api/messages/${m.id}/status`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ status: "delivered" }),
    });
  }
  return toDeliver.length > 0;
}

async function markRead(id) {
  await fetch(`/api/messages/${id}/status`, {
    method: "PATCH",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ status: "read" }),
  });
  loadMessages();
}

async function loadMessages() {
  const res = await fetch(`/api/messages?room_id=${roomId}`);
  const messages = await res.json();

  const delivered = await markDelivered(messages);
  if (delivered) {
    return loadMessages();
  }

  const tbody = document.getElementById("messages-body");
  tbody.innerHTML = "";
  for (const m of messages) {
    const tr = document.createElement("tr");
    const canMarkRead = m.status === "delivered" && !isFromGuest(m.sender);
    tr.innerHTML = `
      <td>${m.sender}</td>
      <td>${m.content}</td>
      <td>${new Date(m.created_at).toLocaleString()}</td>
      <td><span class="badge badge-${m.status}">${m.status}</span></td>
      <td>${canMarkRead ? `<button class="btn btn-secondary" onclick="markRead(${m.id})">Mark read</button>` : "—"}</td>
    `;
    tbody.appendChild(tr);
  }
}

document.getElementById("room-select-form").addEventListener("submit", (e) => {
  e.preventDefault();
  const selectedRoomId = document.getElementById("room-select").value;
  if (!selectedRoomId) return;
  window.location.assign(`/guest_messages.html?room_id=${selectedRoomId}`);
});

document.getElementById("send-form").addEventListener("submit", async (e) => {
  e.preventDefault();
  const content = document.getElementById("send-content").value.trim();
  await fetch("/api/messages", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      room_id: roomId,
      sender: `Guest (Room ${currentRoom.number})`,
      content,
    }),
  });
  document.getElementById("send-content").value = "";
  loadMessages();
});

(async function init() {
  if (!hasRoomId) {
    setChatVisible(false);
    await loadRoomOptions();
    return;
  }

  const room = await loadRoomLabel();
  if (!room) {
    setChatVisible(false);
    await loadRoomOptions();
    return;
  }

  setChatVisible(true);
  await loadMessages();
})();
