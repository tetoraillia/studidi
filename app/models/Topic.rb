class Topic < ApplicationRecord
  belongs_to :course
  has_many :lessons, -> { order(:position) }, dependent: :destroy

  scope :for_course, ->(course_id) { where(course_id: course_id) }
  scope :ordered, -> { order(Arel.sql("COALESCE(position, 9999) ASC"), :created_at) }

  validates :title, valid_characters: true, presence: true, length: { minimum: 5, maximum: 50 }
  validates :course, presence: true
  validates :position, numericality: { greater_than_or_equal_to: 1 }, allow_nil: true
end
