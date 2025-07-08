class Lesson < ApplicationRecord
  belongs_to :course_module

  validates :title, valid_characters: true, presence: true, length: { minimum: 5, maximum: 50 }
  validates :content, valid_characters: true, presence: true, length: { minimum: 10 }, unless: -> { content_type == "video" }
  validates :video_url, presence: true, if: -> { content_type == "video" }
  validates :course_module, presence: true

  def content_required?
    content_type != "video"
  end
end
