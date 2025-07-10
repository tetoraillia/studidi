module AccessChecker
    class CourseAccessChecker
        include Interactor

        before :validate_context!

        def call
            check_access

            if context.success
                context.success
            else
                context.fail!(error: "You are not authorized to access this course.")
            end
        end

        private

        def validate_context!
            if context.course.nil? || context.current_user.nil?
                context.fail!(error: "Invalid context")
            end
        end

        def check_access
            if context.course.instructor_id == context.current_user.id
                context.success = true
            else
                context.success = false
            end
        end
    end
end
