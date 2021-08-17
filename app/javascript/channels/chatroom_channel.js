import consumer from "./consumer"

consumer.subscriptions.create("ChatroomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    scrollToBottom()
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // ActionCable.server.broadcast('chatroom_channel', data)
    // scrollToBottom()
    // $('#messages').append(data['message'])
    // $('#message_content').val('')
    $("#messages").prepend(data)
    scrollToBottom()
    // Called when there's incoming data on the websocket for this channel
  }
});
