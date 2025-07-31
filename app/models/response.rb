class Response < ApplicationRecord
  mount_uploader :attachment, ResponseAttachmentUploader

  belongs_to :responseable, polymorphic: true, optional: true
  belongs_to :user
  has_one :mark

  has_many :notifications, dependent: :destroy, as: :recipient, class_name: "Noticed::Notification"

  scope :for_user, ->(user) { where(user: user) }
  scope :for_lesson, ->(lesson) { where(responseable: lesson) }
  scope :for_questions, ->(questions) { where(responseable: questions) }

  validates :content, presence: true
end
