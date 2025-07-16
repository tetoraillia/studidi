class LessonCloseJob < ApplicationJob
  queue_as :default

  def perform(lesson_id)
    lesson = Lesson.find_by(id: lesson_id)
    return unless lesson && lesson.is_open? && lesson.ends_at <= Time.current

    lesson.update(is_open: false)
  end
end
