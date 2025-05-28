import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["menu", "toggle", "opener"]

    connect() {
        console.log("Mobile navigation controller connected")
    }

    toggleMenu(event) {
        event.preventDefault()
        this.menuTarget.classList.toggle("active")
        this.toggleTarget.classList.toggle("active")
    }

    toggleSubmenu(event) {
        // Tylko na urządzeniach mobilnych
        if (window.innerWidth <= 768) {
            event.preventDefault()
            const opener = event.currentTarget
            opener.classList.toggle("active")

            const submenu = opener.querySelector("ul")
            if (submenu) {
                if (submenu.style.display === "block") {
                    submenu.style.display = "none"
                } else {
                    submenu.style.display = "block"
                }
            }
        }
    }
}