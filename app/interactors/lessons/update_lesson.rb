module Lessons
    class UpdateLesson
        include Interactor

        before :validate_context!

        def call
            update_lesson(context.id, context.params)

            if @lesson.save
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

        def update_lesson(id, params)
            @lesson = Lesson.find(id)
            @lesson.update(params)
        end
    end
end
