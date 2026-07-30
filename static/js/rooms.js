const STATUSES = ["available", "occupied", "cleaning"];
const STATUS_LABELS = {
  available: "Available",
  occupied: "Occupied",
  cleaning: "Cleaning",
};

function renderCurrentDate() {
  const currentDate = document.getElementById("current-date");
  currentDate.dateTime = new Date().toISOString();
  currentDate.textContent = new Intl.DateTimeFormat(document.documentElement.lang, {
    weekday: "long",
    month: "long",
    day: "numeric",
  }).format(new Date());
}

function renderRoomSummary(rooms) {
  const counts = Object.fromEntries(STATUSES.map((status) => [status, 0]));
  for (const room of rooms) {
    counts[room.status] += 1;
  }

  for (const status of STATUSES) {
    document.getElementById(`${status}-count`).textContent = counts[status];
  }
}

function showFeedback(text, type) {
  const feedback = document.getElementById("room-feedback");
  feedback.textContent = text;
  feedback.className = `message room-feedback ${type}`;
  feedback.hidden = false;
}

function createStatusOption(room) {
  return STATUSES.map((status) => `
    <button
      class="status-option status-option--${status}"
      type="button"
      data-status="${status}"
      aria-label="Set room ${room.number} to ${STATUS_LABELS[status]}"
      aria-pressed="${status === room.status}"
      ${status === room.status ? "disabled" : ""}
    >${STATUS_LABELS[status]}</button>
  `).join("");
}

function renderRooms(rooms) {
  const tbody = document.getElementById("rooms-body");
  tbody.innerHTML = "";
  for (const room of rooms) {
    const tr = document.createElement("tr");
    tr.dataset.roomId = room.id;
    tr.dataset.roomNumber = room.number;
    tr.innerHTML = `
      <td>${room.number}</td>
      <td>${room.category}</td>
      <td><span class="badge badge-${room.status}">${STATUS_LABELS[room.status]}</span></td>
      <td>
        <div class="status-options" role="group" aria-label="Set status for room ${room.number}">
          ${createStatusOption(room)}
        </div>
      </td>
    `;
    tbody.appendChild(tr);
  }
}

async function loadRooms() {
  const res = await fetch("/api/rooms");
  if (!res.ok) {
    throw new Error("Could not load rooms");
  }

  const rooms = await res.json();
  renderRoomSummary(rooms);
  renderRooms(rooms);
}

async function changeStatus(button) {
  const row = button.closest("tr");
  const statusOptions = button.closest(".status-options");
  const roomId = row.dataset.roomId;
  const roomNumber = row.dataset.roomNumber;

  statusOptions.querySelectorAll("button").forEach((option) => {
    option.disabled = true;
  });

  try {
    const res = await fetch(`/api/rooms/${roomId}/status`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ status: button.dataset.status }),
    });
    if (!res.ok) {
      throw new Error("Could not update room");
    }

    await loadRooms();
    showFeedback(`Room ${roomNumber} is now ${STATUS_LABELS[button.dataset.status].toLowerCase()}.`, "success");
  } catch {
    statusOptions.querySelectorAll("button").forEach((option) => {
      option.disabled = option.dataset.status === row.querySelector(".badge").textContent.toLowerCase();
    });
    showFeedback(`Room ${roomNumber} could not be updated. Try again.`, "error");
  }
}

document.getElementById("rooms-body").addEventListener("click", (event) => {
  const button = event.target.closest(".status-option");
  if (button) {
    changeStatus(button);
  }
});

renderCurrentDate();
loadRooms().catch(() => {
  showFeedback("Rooms could not be loaded. Refresh the page to try again.", "error");
});
