class CourseReminderJob < ApplicationJob
  queue_as :default

  def perform(course_id)
    course = Course.find_by(id: course_id)
    @students = course.students

    @students.find_each do |student|
      CourseReminderMailer.course_reminder(course, student).deliver_now
    end
  end
end
