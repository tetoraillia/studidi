class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel"
  end

  def unsubscribed
  end

  def receive(data)
    if current_user
      message = current_user.messages.build(content: data["content"])
    else
      message = Message.new(content: data["content"], user_id: nil)
    end

    if message.save
      ActionCable.server.broadcast("chat_channel", {
        id: message.id,
        content: message.content,
        user_id: message.user_id,
        user_name: message.user&.first_name || "Anonymous",
        created_at: message.created_at.strftime("%H:%M")
      })
    else
      puts "Failed to save message: #{message.errors.full_messages.join(', ')}"
    end
  end
end
