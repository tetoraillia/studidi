module Enrollments
  class CheckCourseAvailability
    include Interactor

    def call
      unless context.course.public?
        context.fail!(error: "This course is not available for enrollment.")
      end
    end
  end
end
