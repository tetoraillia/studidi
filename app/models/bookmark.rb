class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :course

  scope :by_user, ->(user) { where(user_id: user.id) }

  validates :user_id, presence: true
  validates :course_id, presence: true,
    uniqueness: { scope: :user_id,
      message: "You have already bookmarked this course." }
end
