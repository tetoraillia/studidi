module Lessons
    class LessonUpdater
        def initialize(id, params)
            @id = id
            @params = params
        end

        def call
            lesson = Lesson.find(@id)
            if lesson.update(@params)
                Result.success(lesson)
            else
                Result.failure(lesson.errors)
            end
        end
    end
end
