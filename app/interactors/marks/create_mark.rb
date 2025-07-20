module Marks
    class CreateMark
        include Interactor

        before :validate_params!

        def call
            mark = Mark.new(context.params)
            mark.lesson = context.lesson
            mark.user = context.user

            response = Response.find_by(id: context.params[:response_id])
            if response.nil?
                context.fail!(error: "Response not found")
                return
            end

            mark.response = response

            if mark.save
                message = "Your response to #{response.lesson.title} was marked #{mark.value} by #{mark.lesson.topic.course.instructor.first_name}"
                url = Rails.application.routes.url_helpers.course_topic_lesson_path(
                    mark.lesson.topic.course,
                    mark.lesson.topic,
                    mark.lesson
                )
                MarkNotifier.with(
                    message: message,
                    url: url,
                    recipient: response.user
                ).deliver_later(response.user)

                context.mark = mark
            else
                context.fail!(error: mark.errors.full_messages.to_sentence)
            end
        end

        private

        def validate_params!
            context.fail!(message: "Missing lesson or user") unless context.lesson && context.user
            context.fail!(message: "Missing params") unless context.params
        end
    end
end
