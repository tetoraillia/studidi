module Enrollments
  class EnrollStudent
    include Interactor::Organizer

    organize CheckStudentRole, CheckCourseAvailability, SaveEnrollment
  end
end
