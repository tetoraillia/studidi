class Question < ApplicationRecord
  belongs_to :lesson

  has_many :options, dependent: :destroy
  has_many :responses, as: :responseable, dependent: :destroy
  accepts_nested_attributes_for :options, allow_destroy: true

  scope :with_lesson, ->(lesson) { where(lesson_id: lesson.id) }

  validates :title, presence: true, length: { minimum: 5, maximum: 200 }

  def correct_option
    options.find_by(is_correct: true)
  end
end
