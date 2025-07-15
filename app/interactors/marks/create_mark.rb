module Marks
    class CreateMark
        include Interactor

        before :validate_params!

        def call
            mark = Mark.new(context.params)
            mark.lesson = context.lesson
            mark.user = context.user
            mark.response = context.response

            if mark.save
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
