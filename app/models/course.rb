class Course < ApplicationRecord
  belongs_to :instructor, class_name: "User"
  has_many :topics, dependent: :destroy
  has_many :lessons, through: :topics
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments, source: :user
  has_many :invitations, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  scope :ordered, -> { order(created_at: :asc) }

  validates :title, valid_characters: true, presence: true, length: { minimum: 5, maximum: 50 }
  validates :description, valid_characters: true, presence: true, length: { minimum: 10, maximum: 300 }
  validates :instructor, presence: true
  validates :public, inclusion: { in: [ true, false ] }

  after_save :schedule_expiration, if: :saved_change_to_ends_at?
  after_save :schedule_reminder, if: :saved_change_to_ends_at?


  def end_date
    ends_at&.strftime("%Y-%m-%d")
  end

  private

  def schedule_reminder
    return unless public? && ends_at.present?

    CourseReminderJob.set(wait_until: (ends_at - 3.days) == Time.current).perform_later(id)
  end

  def schedule_expiration
    return unless public? && ends_at.present?

    CourseExpirationJob.set(wait_until: ends_at).perform_later(id)
  end
end
