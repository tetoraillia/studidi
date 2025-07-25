module Responses
  class AddMarkIdAfterSave
    include Interactor

    def call(response: context.response, mark_id: context.mark.id)
      response.update!(mark_id: mark_id)
      context.response = response
    rescue ActiveRecord::RecordNotFound => e
      context.fail!(error: "Response not found: #{e.message}")
    end
  end
end
