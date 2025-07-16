class CourseReminderMailer < ApplicationMailer
  def course_reminder(course, student)
    @course = course
    @student = student

    mail(
      to: student.email,
      subject: "Reminder: Course '#{course.title}' is ending in 3 days"
    )
  end
end
