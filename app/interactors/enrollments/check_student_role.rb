module Enrollments
  class CheckStudentRole
    include Interactor

    def call
      unless context.user.student?
        context.fail!(error: "Only students can enroll in courses.")
      end
    end
  end
end
