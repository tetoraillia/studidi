module Courses
  class CreateCourse
    include Interactor

    before :validate_context!

    def call
      create_course(context.params)

      if @course.save
        context.course = @course
      else
        context.fail!(error: @course.errors.full_messages.to_sentence)
      end
    end

      private

        def validate_context!
          if context.params.nil? || context.current_user.nil?
            context.fail!(error: "Invalid context")
          end
        end

        def create_course(params)
          @course = Course.new(params)
          @course.instructor = context.current_user
        end
  end
end
