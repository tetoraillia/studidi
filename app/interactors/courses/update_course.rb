module Courses
  class UpdateCourse
    include Interactor

    before :validate_context!

    def call
      update_course(context.id, context.params)

      if @course.save
        check_archived_status
        context.course = @course
      else
        context.fail!(error: @course.errors.full_messages.to_sentence)
      end
    end

      private

        def validate_context!
          if context.id.nil? || context.params.nil? || context.current_user.nil?
            context.fail!(error: "Invalid context")
          end
        end

        def check_archived_status
          @course.update!(is_archived: false) if @course.ends_at.present? && @course.ends_at > Time.current
        end

        def update_course(id, params)
          @course = Course.find(id)
          @course.update(params)
        end
  end
end
