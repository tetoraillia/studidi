class Mark < ApplicationRecord
  belongs_to :lesson
  belongs_to :user
  belongs_to :response, optional: true
  belongs_to :response_user, class_name: "User", optional: true

  has_many :notifications, dependent: :destroy, as: :recipient, class_name: "Noticed::Notification"

  validates :value, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :comment, presence: true, if: :student?
  validates :response, presence: true, if: :teacher?

  def student?
    user.role == "student"
  end

  def teacher?
    response_user&.role == "teacher"
  end
end
