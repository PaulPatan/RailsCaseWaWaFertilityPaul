import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = { roomId: Number }

  connect() {
    this.consumer = createConsumer()
    this.subscription = this.consumer.subscriptions.create(
      { channel: "ChatRoomChannel", chat_room_id: this.roomIdValue },
      {
        received: (data) => {
          this.appendMessage(data.message)
        }
      }
    )
  }

  disconnect() {
    if (this.subscription) {
      this.subscription.unsubscribe()
    }
    if (this.consumer) {
      this.consumer.disconnect()
    }
  }

  appendMessage(messageHtml) {
    const messagesDiv = document.getElementById('messages')
    messagesDiv.insertAdjacentHTML('beforeend', messageHtml)
    this.scrollToBottom()
  }

  scrollToBottom() {
    const container = document.getElementById('messages-container')
    container.scrollTop = container.scrollHeight
  }
}