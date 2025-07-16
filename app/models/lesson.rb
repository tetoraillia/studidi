class Lesson < ApplicationRecord
  has_many :marks, dependent: :destroy
  has_many :responses, dependent: :destroy
  belongs_to :topic

  validates :title, valid_characters: true, presence: true, length: { minimum: 5, maximum: 50 }
  validates :content, valid_characters: true, presence: true, length: { minimum: 10 }, unless: -> { content_type == "video" }
  validates :video_url, presence: true, if: -> { content_type == "video" }
  validates :topic, presence: true
  validates :position, numericality: { greater_than_or_equal_to: 1 }, allow_nil: true

  def content_required?
    content_type != "video"
  end
end
