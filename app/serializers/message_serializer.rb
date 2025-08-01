class MessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :user_id, :user_name, :created_at

  belongs_to :user

  def user_name
    object.user&.first_name || "Anonymous"
  end

  def created_at
    object.created_at.strftime("%H:%M")
  end
end
