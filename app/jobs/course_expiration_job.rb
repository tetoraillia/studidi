class CourseExpirationJob < ApplicationJob
  queue_as :default

  def perform(course_id)
    course = Course.find_by(id: course_id)
    return unless course && course.public? && course.ends_at <= Time.current

    course.update(is_archived: true)
  end
end
