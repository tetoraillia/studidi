module Messages
    class CreateMessage
        include Intecator

        before :validate_params

        def call(params)
            @message = Message.new(params)
            if @message.save
                context.success!(message: "Message created successfully")
            else
                context.fail!(message: "Failed to create message")
            end
        end

        private

        def validate_params
            unless params[:content].present? && params[:user_id].present?
                context.fail!(message: "Missing content or user_id")
            end
        end
    end
end
