module Lessons
    class LessonCreator
        def initialize(params)
            @params = params
        end

        def call
            lesson = Lesson.new(@params)
            if lesson.save
                Result.success(lesson)
            else
                Result.failure(lesson.errors)
            end
        end
    end
end
