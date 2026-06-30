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
        <button class="edit" onclick="editGuest(${g.id}, '${g.first_name}', '${g.last_name}')">Edit</button>
        <button class="danger" onclick="deleteGuest(${g.id})">Delete</button>
      </td>
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

function editGuest(id, firstName, lastName) {
  const first = prompt("First name:", firstName);
  if (first === null) return;
  const last = prompt("Last name:", lastName);
  if (last === null) return;
  fetch(`/api/guests/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ first_name: first, last_name: last }),
  }).then(loadGuests);
}

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
