class Topic < ApplicationRecord
  belongs_to :course
  has_many :lessons, dependent: :destroy

  validates :title, valid_characters: true, presence: true, length: { minimum: 5, maximum: 50 }
  validates :course, presence: true
  validates :position, numericality: { greater_than_or_equal_to: 1 }
end
