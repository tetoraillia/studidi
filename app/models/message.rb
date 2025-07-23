class Message < ApplicationRecord
  belongs_to :user

  validates :content, presence: true, length: { maximum: 300 }
end
