class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :course

  scope :for_user_and_course, ->(user, course) { where(user: user, course: course) }

  validates :user_id, uniqueness: { scope: :course_id }
  validates :user, presence: true
  validates :course, presence: true
end
