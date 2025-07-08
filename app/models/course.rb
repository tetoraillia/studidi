class Course < ApplicationRecord
  belongs_to :instructor, class_name: "User"
  has_many :course_modules, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments, source: :user
  has_many :invitations, dependent: :destroy

  validates :title, valid_characters: true, presence: true, length: { minimum: 5, maximum: 50 }
  validates :description, valid_characters: true, presence: true, length: { minimum: 10, maximum: 300 }
  validates :instructor, presence: true
  validates :public, inclusion: { in: [true, false] }
end
