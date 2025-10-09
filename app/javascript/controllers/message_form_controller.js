import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "submit"]

  connect() {
    this.scrollToBottom()
  }

  submit(event) {
    event.preventDefault()
    const content = this.inputTarget.value.trim()
    
    if (content === '') {
      return
    }

    this.submitTarget.disabled = true
    this.submitTarget.textContent = 'Sending...'
    
    fetch(this.element.action, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        message: { content: content }
      })
    })
    .then(response => {
      if (response.ok) {
        this.inputTarget.value = ''
        this.inputTarget.focus()
      }
    })
    .catch(error => {
      console.error('Error:', error)
    })
    .finally(() => {
      this.submitTarget.disabled = false
      this.submitTarget.textContent = 'Send'
    })
  }

  handleKeydown(event) {
    if (event.key === 'Enter' && !event.shiftKey) {
      event.preventDefault()
      this.submit(event)
    }
  }

  scrollToBottom() {
    setTimeout(() => {
      const container = document.getElementById('messages-container')
      if (container) {
        container.scrollTop = container.scrollHeight
      }
    }, 100)
  }
}