module AccessChecker
    class CourseAccessChecker
        def initialize(course:, user:)
            @course = course
            @user = user
        end

        def call
            if @user == @course.instructor
                Result.success
            else
                Result.failure
            end
        end
    end
end
