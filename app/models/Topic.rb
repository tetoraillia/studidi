class Topic < ApplicationRecord
  belongs_to :course
  has_many :lessons, dependent: :destroy

  validates :title, valid_characters: true, presence: true, length: { minimum: 5, maximum: 50 }
  validates :course, presence: true
end
