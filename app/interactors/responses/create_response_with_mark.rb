module Responses
    class CreateResponseWithMark
        include Interactor::Organizer

        organize Responses::CreateResponse, Marks::CreateMark

        def call
            super
            context.mark_id = context.mark.id
        end
    end
end
