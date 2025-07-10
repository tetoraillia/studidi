module Topics
  class CheckInstructor
    include Interactor

    def call
        if context.user == context.course.instructor
            context.success = true
        else
            context.fail!(error: "You must be the instructor of this course to perform this action.")
        end
    end
  end
end