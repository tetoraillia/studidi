module Marks
    class UpdateMark < ApplicationInteractor
        def call
            mark = Mark.find(context.id)
            mark.update(context.params)

            if mark.save
                context.mark = mark
            else
                context.fail!(error: mark.errors.full_messages.to_sentence)
            end
        end
    end
end
