class Option < ApplicationRecord
  belongs_to :question

  scope :with_questions, ->(question_id) { where(question_id: question_id) }

  validates :title, presence: true, length: { minimum: 1, maximum: 100 }
end
