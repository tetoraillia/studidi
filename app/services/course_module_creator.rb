module CourseModules
    class CourseModuleCreator
        def initialize(course_module_params)
            @course_module_params = course_module_params
        end

        def call
            course_module = CourseModule.new(@course_module_params)
            if course_module.save
                Result.success(course_module)
            else
                Result.failure(course_module.errors)
            end
        end
    end
end
