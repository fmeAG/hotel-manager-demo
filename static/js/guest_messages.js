const GUEST_SENDER_PREFIX = "Guest (";

const params = new URLSearchParams(window.location.search);
const roomId = Number(params.get("room_id"));
let currentRoom = null;

function isFromGuest(sender) {
  return sender.startsWith(GUEST_SENDER_PREFIX);
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
  const room = await loadRoomLabel();
  if (!room) return;
  await loadMessages();
})();
