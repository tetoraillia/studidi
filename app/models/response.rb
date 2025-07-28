class Response < ApplicationRecord
  mount_uploader :attachment, ResponseAttachmentUploader

  belongs_to :responseable, polymorphic: true, optional: true
  belongs_to :user
  has_one :mark

  has_many :notifications, dependent: :destroy, as: :recipient, class_name: "Noticed::Notification"

  validates :content, presence: true
  validates :user_id, uniqueness: { scope: [:responseable_type, :responseable_id], message: "can only have one response per item" }
end
