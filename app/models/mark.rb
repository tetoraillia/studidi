class Mark < ApplicationRecord
  belongs_to :lesson
  belongs_to :user
  belongs_to :response, optional: true

  has_many :notifications, dependent: :destroy, as: :recipient, class_name: "Noticed::Notification"

  validates :value, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :response, presence: true, if: :teacher?

  scope :for_user, ->(user) { where(user: user) }
  scope :for_lesson, ->(lesson) { where(lesson: lesson) }

  def student?
    user.role == "student"
  end

  def teacher?
    user.role == "teacher"
  end
end
