class Lesson < ApplicationRecord
  belongs_to :course_module, dependent: :destroy
end
