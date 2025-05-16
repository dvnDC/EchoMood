import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        this.element.querySelectorAll('.mood-cell:not(.empty)').forEach(cell => {
            cell.addEventListener('click', this.handleCellClick.bind(this))
        })
    }

    handleCellClick(event) {
        const cell = event.currentTarget
        const date = cell.dataset.date
        const entryId = cell.dataset.entryId

        if (entryId) {
            window.location.href = `/mood_entries/${entryId}`
        }
    }
}