// app/javascript/controllers/users_index_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["userTable", "searchInput", "sortButton"]

    connect() {
        console.log("Users Index controller connected")
    }

    // Wyszukiwanie użytkowników
    search() {
        const searchTerm = this.searchInputTarget.value.toLowerCase()
        const rows = this.userTableTarget.querySelectorAll("tbody tr")

        rows.forEach(row => {
            const email = row.querySelector(".user-email").textContent.toLowerCase()
            const roles = Array.from(row.querySelectorAll(".role-badge")).map(badge =>
                badge.textContent.toLowerCase()
            ).join(" ")

            const matchesSearch = email.includes(searchTerm) || roles.includes(searchTerm)
            row.style.display = matchesSearch ? "" : "none"
        })
    }

    // Sortowanie tabeli
    sort(event) {
        const column = event.currentTarget.closest("th")
        const columnIndex = Array.from(column.parentNode.children).indexOf(column)
        const currentDirection = column.getAttribute("data-sort-direction") || "asc"
        const newDirection = currentDirection === "asc" ? "desc" : "asc"

        // Resetuj kierunek sortowania dla wszystkich kolumn
        this.sortButtonTargets.forEach(button => {
            const th = button.closest("th")
            th.setAttribute("data-sort-direction", "")
            button.classList.remove("sorted-asc", "sorted-desc")
        })

        // Ustaw nowy kierunek sortowania dla bieżącej kolumny
        column.setAttribute("data-sort-direction", newDirection)
        event.currentTarget.classList.add(`sorted-${newDirection}`)

        // Wykonaj sortowanie
        this.sortTable(columnIndex, newDirection)
    }

    sortTable(columnIndex, direction) {
        const rows = Array.from(this.userTableTarget.querySelectorAll("tbody tr"))
        const multiplier = direction === "asc" ? 1 : -1

        const sortedRows = rows.sort((rowA, rowB) => {
            let valueA, valueB

            // Wybierz odpowiednią wartość do porównania w zależności od kolumny
            if (columnIndex === 0) { // Email
                valueA = rowA.querySelector(".user-email").textContent.toLowerCase()
                valueB = rowB.querySelector(".user-email").textContent.toLowerCase()
            } else if (columnIndex === 1) { // Role
                valueA = rowA.querySelectorAll(".role-badge").length
                valueB = rowB.querySelectorAll(".role-badge").length
            } else if (columnIndex === 2) { // Data rejestracji
                valueA = new Date(rowA.querySelector(".created-at .date").textContent + " " +
                    rowA.querySelector(".created-at .time").textContent)
                valueB = new Date(rowB.querySelector(".created-at .date").textContent + " " +
                    rowB.querySelector(".created-at .time").textContent)
            }

            if (valueA < valueB) return -1 * multiplier
            if (valueA > valueB) return 1 * multiplier
            return 0
        })

        // Przebuduj tabelę z posortowanymi wierszami
        const tbody = this.userTableTarget.querySelector("tbody")
        sortedRows.forEach(row => tbody.appendChild(row))
    }
}