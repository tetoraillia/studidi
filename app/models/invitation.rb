class Invitation < ApplicationRecord
  belongs_to :course
  belongs_to :invited_by, class_name: "User"

  validates :email, presence: true
  validates :token, presence: true, uniqueness: true

  before_validation :generate_token, on: :create

  private

  def generate_token
    self.token ||= SecureRandom.hex(20)
  end
end
