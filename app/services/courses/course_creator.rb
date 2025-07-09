module Courses
  class CourseCreator
    def initialize(course_params)
      @course_params = course_params
    end

    def call
      course = Course.new(@course_params)
      if course.save
        Result.success(course)
      else
        Result.failure(course.errors)
      end
    end
  end
end
