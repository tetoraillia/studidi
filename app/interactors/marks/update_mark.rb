module Marks
    class UpdateMark
        include Interactor
        
        def call
            mark = Mark.find_by(id: context.id) || Mark.find_by(response_id: context.response_id)
            
            if mark.nil?
                context.fail!(error: "Mark not found")
                return
            end
            
            mark_params = context.params.slice(:value, :comment)
            
            if mark.update(mark_params)
                context.mark = mark
            else
                context.fail!(error: mark.errors.full_messages.to_sentence)
            end
        end
    end
end
