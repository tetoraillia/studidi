module Lessons
    class UpdateLesson
        include Interactor

        before :validate_context!

        def call
            update_lesson(context.id, context.params)

            if @lesson.save
                message = "Teacher #{@lesson.topic.course.instructor.first_name} posted a new lesson: #{@lesson.title}"
                url = Rails.application.routes.url_helpers.lesson_path(@lesson)
                @lesson.topic.course.students.each do |student|
                    LessonNotifier.with(
                        message: message,
                        url: url,
                    ).deliver_later(student)
                end

                check_lesson_open_status
                context.lesson = @lesson
            else
                context.fail!(error: @lesson.errors.full_messages.to_sentence)
            end
        end

        private

        def validate_context!
            if context.id.nil? || context.params.nil? || context.course.nil? || context.topic.nil?
                context.fail!(error: "Invalid context")
            end
        end

        def check_lesson_open_status
            @lesson.update!(is_open: true) if @lesson.ends_at > Time.current
        end

        def update_lesson(id, params)
            @lesson = Lesson.find(id)
            @lesson.update(params)
        end
    end
end
