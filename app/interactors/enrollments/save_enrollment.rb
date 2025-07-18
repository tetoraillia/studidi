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

            #EnrollmentNotifier.with(record: context.enrollment, message: "Student #{context.user.first_name} enrolled on your course: #{context.course.title}").deliver(context.course.instructor)
            NotificationsChannel.broadcast_to(context.course.instructor, { message: "Student #{context.user.first_name} enrolled on your course: #{context.course.title}" })

            context.message = "Successfully enrolled in the course."
        end
    end
end
