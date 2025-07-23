module Responses
  class AddMarkIdAfterSave
    include Interactor

    def call(response: context.response, mark_id: context.mark.id)
      response.update!(mark_id: mark_id)
      context.response = response
  rescue ActiveRecord::RecordInvalid => e
    context.fail!(error: e.message)
    end
  end
end
