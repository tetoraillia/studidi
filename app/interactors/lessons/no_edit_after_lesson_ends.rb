module Lessons
  class NoEditAfterLessonEnds
    include Interactor

    before :validate_params!

    def call
      if context.lesson.ends_at.present? && context.lesson.ends_at < Time.current
        context.fail!(error: "Lesson has already ended.")
      end

      context.message = "Lesson is open."
    end

    private

      def validate_params!
        context.fail!(error: "Lesson is not found.") unless context.lesson
      end
  end
end
