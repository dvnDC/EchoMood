import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggle", "menu", "overlay"]

  connect() {
    console.log("Mobile navigation controller connected") // DEBUG
    console.log("Targets found:", {
      toggle: this.hasToggleTarget,
      menu: this.hasMenuTarget,
      overlay: this.hasOverlayTarget
    }) // DEBUG
    
    this.handleResize = this.handleResize.bind(this)
    window.addEventListener('resize', this.handleResize)
  }

  disconnect() {
    console.log("Mobile navigation controller disconnected") // DEBUG
    window.removeEventListener('resize', this.handleResize)
  }

  toggleMenu() {
    console.log("Toggle menu called") // DEBUG
    this.toggleTarget.classList.toggle('active')
    this.menuTarget.classList.toggle('active')
    this.overlayTarget.classList.toggle('active')
    
    // Prevent body scrolling when menu is open
    if (this.menuTarget.classList.contains('active')) {
      document.body.style.overflow = 'hidden'
    } else {
      document.body.style.overflow = ''
    }
  }

  closeMenu() {
    console.log("Close menu called") // DEBUG
    this.toggleTarget.classList.remove('active')
    this.menuTarget.classList.remove('active')
    this.overlayTarget.classList.remove('active')
    document.body.style.overflow = ''
    
    // Close all open dropdowns
    this.menuTarget.querySelectorAll('.opener.active').forEach(opener => {
      opener.classList.remove('active')
    })
  }

  handleDropdown(event) {
    console.log("Handle dropdown called", event) // DEBUG
    // Only handle dropdowns on mobile
    if (window.innerWidth <= 768) {
      event.preventDefault()
      
      const parentLi = event.target.closest('li.opener')
      if (parentLi) {
        parentLi.classList.toggle('active')
        
        // Close other open dropdowns at the same level
        const siblingOpeners = Array.from(parentLi.parentElement.children)
          .filter(li => li.classList.contains('opener') && li !== parentLi)
        
        siblingOpeners.forEach(opener => {
          opener.classList.remove('active')
        })
      }
    }
  }

  handleResize() {
    console.log("Handle resize called, width:", window.innerWidth) // DEBUG
    // Close menu when window is resized to desktop
    if (window.innerWidth > 768) {
      this.closeMenu()
    }
  }
}