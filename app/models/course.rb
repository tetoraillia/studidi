class Course < ApplicationRecord
  belongs_to :instructor, class_name: "User"
  has_many :topics, dependent: :destroy
  has_many :lessons, through: :topics
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments, source: :user
  has_many :invitations, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  scope :ordered, -> { order(created_at: :asc) }
  scope :lessonable, ->(value = true) {
    if ActiveRecord::Type::Boolean.new.cast(value)
      joins(:topics).where(topics: { id: Lesson.select(:topic_id) }).distinct
    else
      all
    end
  }
  scope :enrolled, ->(user_id = nil) {
    if user_id.present?
      joins(:enrollments).where(enrollments: { user_id: user_id }).distinct
    else
      all
    end
  }
  scope :recent, -> { where("created_at >= ?", 1.week.ago) }

  validates :title, valid_characters: true, presence: true, length: { minimum: 5, maximum: 50 }
  validates :description, valid_characters: true, presence: true, length: { minimum: 10, maximum: 300 }
  validates :instructor, presence: true
  validates :public, inclusion: { in: [ true, false ] }

  after_save :schedule_expiration, if: :saved_change_to_ends_at?
  after_save :schedule_reminder, if: :saved_change_to_ends_at?

  def end_date
    ends_at&.strftime("%Y-%m-%d")
  end

  def enrolled?(user)
    return false unless user
    enrollments.exists?(user_id: user.id)
  end

  private

    def self.ransackable_attributes(auth_object = nil)
      [ "description", "instructor_id", "is_archived", "public", "title" ]
    end

    def self.ransackable_associations(auth_object = nil)
      [ "bookmarks", "enrollments", "instructor", "invitations", "lessons", "students", "topics" ]
    end

    def self.ransackable_associations(auth_object = nil)
      [ "bookmarks", "enrollments", "instructor", "invitations", "lessons", "students", "topics" ]
    end

    def self.ransackable_scopes(auth_object = nil)
      [ "lessonable", "enrolled", "recent" ]
    end

    def schedule_reminder
      return unless public? && ends_at.present?

      CourseReminderJob.set(wait_until: (ends_at - 3.days) == Time.current).perform_later(id)
    end

    def schedule_expiration
      return unless public? && ends_at.present?

      CourseExpirationJob.set(wait_until: ends_at).perform_later(id)
    end
end
