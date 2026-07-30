const NEXT_STATUS = { sent: "delivered", delivered: "read", read: null };
let roomNumbersById = {};

async function loadRoomOptions() {
  const res = await fetch("/api/rooms");
  const rooms = await res.json();
  roomNumbersById = Object.fromEntries(rooms.map(r => [r.id, r.number]));

  const sendSelect = document.getElementById("send-room");
  const filterSelect = document.getElementById("filter-room");
  sendSelect.innerHTML = rooms.map(r => `<option value="${r.id}">${r.number}</option>`).join("");
  filterSelect.innerHTML =
    `<option value="">All rooms</option>` +
    rooms.map(r => `<option value="${r.id}">${r.number}</option>`).join("");
}

async function loadMessages() {
  const roomId = document.getElementById("filter-room").value;
  const url = roomId ? `/api/messages?room_id=${roomId}` : "/api/messages";
  const res = await fetch(url);
  const messages = await res.json();
  const tbody = document.getElementById("messages-body");
  tbody.innerHTML = "";
  for (const m of messages) {
    const tr = document.createElement("tr");
    const next = NEXT_STATUS[m.status];
    tr.innerHTML = `
      <td>${roomNumbersById[m.room_id] ?? m.room_id}</td>
      <td>${m.sender}</td>
      <td>${m.content}</td>
      <td>${new Date(m.created_at).toLocaleString()}</td>
      <td><span class="badge badge-${m.status}">${m.status}</span></td>
      <td>${next ? `<button class="btn btn-secondary" onclick="advanceStatus(${m.id}, '${next}')">Mark ${next}</button>` : "—"}</td>
      <td><a href="/guest_messages.html?room_id=${m.room_id}" target="_blank">Open</a></td>
    `;
    tbody.appendChild(tr);
  }
}

async function advanceStatus(id, status) {
  await fetch(`/api/messages/${id}/status`, {
    method: "PATCH",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ status }),
  });
  loadMessages();
}

document.getElementById("filter-room").addEventListener("change", loadMessages);

document.getElementById("send-form").addEventListener("submit", async (e) => {
  e.preventDefault();
  const room_id = Number(document.getElementById("send-room").value);
  const sender = document.getElementById("send-sender").value.trim();
  const content = document.getElementById("send-content").value.trim();
  await fetch("/api/messages", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ room_id, sender, content }),
  });
  document.getElementById("send-content").value = "";
  loadMessages();
});

(async function init() {
  await loadRoomOptions();
  await loadMessages();
})();
