class Lesson < ApplicationRecord
  belongs_to :course_module

  validates :title, valid_characters: true, presence: true, length: { minimum: 5, maximum: 50 }
  validates :content, valid_characters: true, presence: true, length: { minimum: 10 }
  validates :course_module, presence: true
end