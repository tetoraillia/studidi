module Responses
  class CreateResponse
    include Interactor

    before :validate_params!

    def call
      @response = Response.new(context.params)
      @response.lesson = context.lesson
      @response.user = context.user

      if @response.save
        message = "Student #{@response.user.first_name} sent you a response to #{@response.lesson.title}"
        url = Rails.application.routes.url_helpers.course_topic_lesson_path(
            @response.lesson.topic.course,
            @response.lesson.topic,
            @response.lesson
        )

        ResponseNotifier.with(
            message: message,
            url: url,
        ).deliver_later(@response.lesson.topic.course.instructor)

        context.response = @response
        context.lesson.update!(student_response_id: @response.id)
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
