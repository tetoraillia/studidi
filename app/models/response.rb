class Response < ApplicationRecord
    belongs_to :lesson
    belongs_to :user
    has_one :mark

    validates :content, presence: true
    validates :user_id, uniqueness: { scope: :lesson_id, message: "can only have one response per lesson" }
end
