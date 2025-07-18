class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :course

  has_many :notifications, dependent: :destroy, as: :recipient, class_name: "Noticed::Notification"

  scope :for_user_and_course, ->(user, course) { where(user: user, course: course) }

  validates :user_id, uniqueness: { scope: :course_id }
  validates :user, presence: true
  validates :course, presence: true
end
