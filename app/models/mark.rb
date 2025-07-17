class Mark < ApplicationRecord
  belongs_to :lesson
  belongs_to :user
  belongs_to :response, optional: true

  validates :value, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :comment, presence: true, if: :student?
  validates :response, presence: true, if: :teacher?

  def student?
    user.role == "student"
  end

  def teacher?
    response&.user&.role == "teacher"
  end
end
