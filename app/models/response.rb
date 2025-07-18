class Response < ApplicationRecord
    belongs_to :lesson, optional: true
    belongs_to :user
    has_one :mark
    before_destroy :nullify_lesson_id

    has_many :notifications, dependent: :destroy, as: :recipient, class_name: "Noticed::Notification"

    validates :content, presence: true
    validates :user_id, uniqueness: { scope: :lesson_id, message: "can only have one response per lesson" }
  private

  def nullify_lesson_id
    self.lesson_id = nil
  end
end
