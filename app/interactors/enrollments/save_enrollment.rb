module Enrollments
  class SaveEnrollment
    include Interactor

    def call
      enrollment = Enrollment.find_or_initialize_by(user: context.user, course: context.course)
      context.enrollment = enrollment

      if enrollment.persisted?
        context.message = "You are already enrolled in this course."
        return
      end

      enrollment.enrolled_at = Time.current

      unless enrollment.save
        context.fail!(error: "Could not enroll in the course.")
        return
      end

      message = "Student #{context.user.first_name} enrolled on your course: #{context.course.title}"
      url = Rails.application.routes.url_helpers.course_path(context.course)
      ApplicationNotifier.with(
          message: message,
          url: url,
          type: "Enrollment"
      ).deliver_later(context.course.instructor)

      context.message = "Successfully enrolled in the course."
    end
  end
end
