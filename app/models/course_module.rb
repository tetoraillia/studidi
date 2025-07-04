class CourseModule < ApplicationRecord
  belongs_to :course, dependent: :destroy
end
