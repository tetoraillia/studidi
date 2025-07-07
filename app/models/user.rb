class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :role, presence: true, inclusion: { in: [ "student", "teacher" ] }

  has_many :enrollments, dependent: :destroy
  has_many :enrolled_courses, through: :enrollments, source: :course

  def teacher?
    role == "teacher"
  end

  def student?
    role == "student"
  end
end
