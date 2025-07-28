module Responses
  class CreateResponseWithMark
    include Interactor::Organizer

    def call
      if context.user.student?
        Responses::CreateResponse.call(context.to_h)
      else
        Responses::CreateResponse.call(context.to_h)
        Marks::CreateMark.call(context.to_h)
      end
    end
  end
end
