class Course < ApplicationRecord
  belongs_to :instructor, class_name: 'User'
end
