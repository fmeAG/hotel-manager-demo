async function loadSelects() {
  const [guestsRes, roomsRes] = await Promise.all([
    fetch("/api/guests"),
    fetch("/api/rooms"),
  ]);
  const guests = await guestsRes.json();
  const rooms = await roomsRes.json();

  const checkinGuest = document.getElementById("checkin-guest");
  const checkinRoom = document.getElementById("checkin-room");
  const checkoutGuest = document.getElementById("checkout-guest");

  const notCheckedIn = guests.filter(g => g.room_id === null);
  const checkedIn = guests.filter(g => g.room_id !== null);
  const available = rooms.filter(r => r.status === "available");

  checkinGuest.innerHTML = notCheckedIn.length
    ? notCheckedIn.map(g => `<option value="${g.id}">${g.first_name} ${g.last_name}</option>`).join("")
    : '<option disabled>No guests without room</option>';

  checkinRoom.innerHTML = available.length
    ? available.map(r => `<option value="${r.id}">Room ${r.number} (${r.category})</option>`).join("")
    : '<option disabled>No available rooms</option>';

  checkoutGuest.innerHTML = checkedIn.length
    ? checkedIn.map(g => `<option value="${g.id}">${g.first_name} ${g.last_name} (Room ${g.room_id})</option>`).join("")
    : '<option disabled>No guests checked in</option>';
}

function showMessage(text, type) {
  const el = document.getElementById("message");
  el.className = `message ${type}`;
  el.textContent = text;
  setTimeout(() => { el.textContent = ""; el.className = ""; }, 4000);
}

document.getElementById("checkin-form").addEventListener("submit", async (e) => {
  e.preventDefault();
  const guestId = document.getElementById("checkin-guest").value;
  const roomId = document.getElementById("checkin-room").value;
  if (!guestId || !roomId) return;
  const res = await fetch(`/api/guests/${guestId}/checkin`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ room_id: parseInt(roomId) }),
  });
  if (res.ok) {
    showMessage("Check-in successful.", "success");
    loadSelects();
  } else {
    const err = await res.json();
    showMessage(err.detail, "error");
  }
});

document.getElementById("checkout-form").addEventListener("submit", async (e) => {
  e.preventDefault();
  const guestId = document.getElementById("checkout-guest").value;
  if (!guestId) return;
  const res = await fetch(`/api/guests/${guestId}/checkout`, { method: "POST" });
  if (res.ok) {
    showMessage("Check-out successful.", "success");
    loadSelects();
  } else {
    const err = await res.json();
    showMessage(err.detail, "error");
  }
});

loadSelects();
