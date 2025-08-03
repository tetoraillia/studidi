class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :role, presence: true, inclusion: { in: [ "student", "teacher" ] }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :enrollments, dependent: :destroy
  has_many :enrolled_courses, through: :enrollments, source: :course
  has_many :marks, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_many :notifications, dependent: :destroy, as: :recipient, class_name: "Noticed::Notification"

  has_many :courses, foreign_key: :instructor_id, dependent: :destroy

  mount_uploader :avatar, UserAvatarUploader

  before_create :set_last_name

  def set_last_name
    self.last_name = "unknown" if last_name.blank?
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.avatar = auth.info.image
    end
  end

  def teacher?
    role == "teacher"
  end

  def student?
    role == "student"
  end

  def enrolled_in?(course)
    enrolled_courses.include?(course)
  end
end
