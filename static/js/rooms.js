const STATUSES = ["available", "occupied", "cleaning"];

async function loadRooms() {
  const res = await fetch("/api/rooms");
  const rooms = await res.json();
  const tbody = document.getElementById("rooms-body");
  tbody.innerHTML = "";
  for (const room of rooms) {
    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td>${room.number}</td>
      <td>${room.category}</td>
      <td class="status-${room.status}">${room.status}</td>
      <td>
        <select data-id="${room.id}">
          ${STATUSES.map(s => `<option value="${s}"${s === room.status ? " selected" : ""}>${s}</option>`).join("")}
        </select>
        <button onclick="changeStatus(${room.id}, this.previousElementSibling)">Save</button>
      </td>
    `;
    tbody.appendChild(tr);
  }
}

async function changeStatus(roomId, select) {
  await fetch(`/api/rooms/${roomId}/status`, {
    method: "PATCH",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ status: select.value }),
  });
  loadRooms();
}

loadRooms();
