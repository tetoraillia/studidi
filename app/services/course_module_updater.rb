class CourseModuleUpdater
    def initialize(id, params)
        @id = id
        @params = params
    end

    def call
        course_module = CourseModule.find(@id)
        if course_module.update(@params)
            Result.success(course_module)
        else
            Result.failure(course_module.errors)
        end
    end
end
