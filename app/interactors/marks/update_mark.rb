module Marks
    class UpdateMark
        include Interactor

        def call
            mark = Mark.find_by(id: context.id) || Mark.find_by(response_id: context.response_id)

            if mark.nil?
                context.fail!(error: "Mark not found")
                return
            end

            response = mark.response
            mark_params = context.params.slice(:value, :comment)

            if mark.update(mark_params)
                message = "Your response to #{response.lesson.title} was remarked #{mark.value} by #{mark.lesson.topic.course.instructor.first_name}"
                url = Rails.application.routes.url_helpers.course_topic_lesson_path(
                    mark.lesson.topic.course,
                    mark.lesson.topic,
                    mark.lesson
                )

                MarkNotifier.with(
                    message: message,
                    url: url,
                ).deliver_later(response.user)

                context.mark = mark
            else
                context.fail!(error: mark.errors.full_messages.to_sentence)
            end
        end
    end
end
