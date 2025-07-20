module Marks
    class UpdateMark < ApplicationInteractor
        def call
            mark = Mark.find(context.id)
            mark.update(context.params)

            if mark.save
                message = "Your response to #{response.lesson.title} was remarked #{mark.value} by #{mark.lesson.topic.course.instructor.first_name}"
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
    end
end
