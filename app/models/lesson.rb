class Lesson < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :responses, as: :responseable
  has_many :marks, dependent: :destroy
  has_many :responses, through: :marks, dependent: :destroy
  has_many :notifications, dependent: :destroy, as: :recipient, class_name: "Noticed::Notification"
  belongs_to :topic

  scope :ordered, -> { order(Arel.sql("COALESCE(position, 9999) ASC"), :created_at) }

  before_validation :set_default_content_type

  validates :title, valid_characters: true, presence: true, length: { minimum: 5, maximum: 50 }
  validates :content, valid_characters: true, presence: true, length: { minimum: 10 }, unless: -> { content_type == "video" }
  validates :video_url, presence: true, if: -> { content_type == "video" }
  validates :topic, presence: true
  validates :position, numericality: { greater_than_or_equal_to: 1 }, allow_nil: true

  ALLOWED_CONTENT_TYPES = [ "text", "video", "quiz" ].freeze

  before_validation :ensure_lesson_ends_before_course
  after_save :schedule_expiration, if: :saved_change_to_ends_at?

  def self.ransackable_attributes(auth_object = nil)
    %w[title content_type topic_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[topic marks responses]
  end

  def end_date
    ends_at&.strftime("%Y-%m-%d %H:%M")
  end

  private

    def ensure_lesson_ends_before_course
      return unless topic&.course&.ends_at.present? && ends_at.present?

      if ends_at > topic.course.ends_at
        self.ends_at = topic.course.ends_at
      end
    end

    def schedule_expiration
      return unless is_open? && ends_at.present?

      LessonCloseJob.set(wait_until: ends_at).perform_later(id)
    end

    def content_required?
      content_type != "video"
    end

    def set_default_content_type
      self.content_type = "text" if content_type.blank? || !ALLOWED_CONTENT_TYPES.include?(content_type)
    end
end
