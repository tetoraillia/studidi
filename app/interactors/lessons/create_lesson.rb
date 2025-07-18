module Lessons
    class CreateLesson
        include Interactor

        before :validate_context!

        def call
            create_lesson(context.params)

            if @lesson.save
                @lesson.topic.course.students.each do |student|
                    NotificationsChannel.broadcast_to(student, { message: "Teacher #{@lesson.topic.course.instructor.first_name} posted new lesson" })
                end
                #LessonNotifier.with(record: @lesson, message: "Teacher #{@lesson.topic.course.instructor.first_name} posted new lesson").deliver(@lesson.topic.course.students)
                context.lesson = @lesson
            else
                context.fail!(error: @lesson.errors.full_messages.to_sentence)
            end
        end

        private

        def validate_context!
            if context.params.nil? || context.course.nil? || context.topic.nil?
                context.fail!(error: "Invalid context")
            end
        end

        def create_lesson(params)
            @lesson = Lesson.new(params)
            @lesson.topic = context.topic
        end
    end
end
