module Courses
  class CourseUpdater
    def initialize(id, params)
      @id = id
      @params = params
    end

    def call
      course = Course.find(@id)
      if course.update(@params)
        Result.success(course)
      else
        Result.failure(course.errors)
      end
    end
  end
end
