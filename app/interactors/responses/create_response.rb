module Responses
  class CreateResponse
    include Interactor

    before :validate_params!

    def call
      params = context.params.dup
      params.delete(:lesson_id)
      @response = Response.new(params)
      @response.responseable = context.lesson
      @response.user = context.user

      if @response.save
        lesson = @response.responseable # теперь это Lesson
        message = "Student #{@response.user.first_name} sent you a response to #{lesson.title}"
        url = Rails.application.routes.url_helpers.course_topic_lesson_path(
            lesson.topic.course,
            lesson.topic,
            lesson
        )

        ApplicationNotifier.with(
            message: message,
            url: url,
        ).deliver_later(lesson.topic.course.instructor)

        context.response = @response
        lesson.update!(student_response_id: @response.id)
      else
        context.fail!(error: @response.errors.full_messages.to_sentence)
      end
    end

      private

        def validate_params!
          context.fail!(message: "Missing lesson or user") unless context.lesson && context.user
          context.fail!(message: "Missing params") unless context.params
        end
  end
end
