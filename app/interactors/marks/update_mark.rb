module Marks
    class UpdateMark < ApplicationInteractor
        def call
            mark = Mark.find(context.id)
            mark.update(context.params)

            if mark.save
                MarkNotifier.with(record: mark, message: "Your response to #{response.lesson.title} was remarked #{mark.value} by #{mark.lesson.topic.course.instructor.first_name}").deliver(response.user)
                context.mark = mark
            else
                context.fail!(error: mark.errors.full_messages.to_sentence)
            end
        end
    end
end
