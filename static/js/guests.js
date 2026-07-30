async function loadGuests() {
  const res = await fetch("/api/guests");
  const guests = await res.json();
  const tbody = document.getElementById("guests-body");
  tbody.innerHTML = "";
  for (const g of guests) {
    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td>${g.first_name} ${g.last_name}</td>
      <td>${g.room_id ?? "—"}</td>
      <td>${g.check_in_date ?? "—"}</td>
      <td>${g.check_out_date ?? "—"}</td>
      <td>
        <button class="btn btn-secondary" onclick='openEditGuest(${g.id}, ${JSON.stringify(g.first_name)}, ${JSON.stringify(g.last_name)})'>Edit</button>
        <button class="btn btn-danger" onclick="deleteGuest(${g.id})">Delete</button>
    `;
    tbody.appendChild(tr);
  }
}

async function deleteGuest(id) {
  if (!confirm("Delete this guest?")) return;
  const res = await fetch(`/api/guests/${id}`, { method: "DELETE" });
  if (!res.ok) {
    const err = await res.json();
    alert(err.detail);
    return;
  }
  loadGuests();
}

const editDialog = document.getElementById("edit-guest-dialog");
const editForm = document.getElementById("edit-form");
let editingGuestId = null;

function openEditGuest(id, firstName, lastName) {
  editingGuestId = id;
  document.getElementById("edit-first-name").value = firstName;
  document.getElementById("edit-last-name").value = lastName;
  editDialog.showModal();
}

document.getElementById("edit-cancel").addEventListener("click", () => {
  editDialog.close();
});

editForm.addEventListener("submit", async (e) => {
  e.preventDefault();
  const first = document.getElementById("edit-first-name").value.trim();
  const last = document.getElementById("edit-last-name").value.trim();
  await fetch(`/api/guests/${editingGuestId}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ first_name: first, last_name: last }),
  });
  editDialog.close();
  loadGuests();
});

document.getElementById("add-form").addEventListener("submit", async (e) => {
  e.preventDefault();
  const first = document.getElementById("first-name").value.trim();
  const last = document.getElementById("last-name").value.trim();
  await fetch("/api/guests", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ first_name: first, last_name: last }),
  });
  e.target.reset();
  loadGuests();
});

loadGuests();
