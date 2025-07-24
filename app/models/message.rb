class Message < ApplicationRecord
  belongs_to :user

  validates :content, presence: true, length: { maximum: 300 }

  after_create_commit { broadcast_message }

  private

    def broadcast_message
      ActionCable.server.broadcast("chat_channel", {
        id: id,
        content: content,
        user_name: user.first_name,
        created_at: created_at.strftime("%H:%M:%S")
      })
      puts "Message broadcasted to chat_channel: #{content}"
    end
end
