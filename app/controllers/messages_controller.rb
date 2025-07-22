class MessagesController < ApplicationController
    before_action :authenticate_user!

    def index
        @messages = Message.all
        @users = User.all
    end

    def create
        @message = current_user.messages.build(message_params.except(:user_id))
        if @message.save
            respond_to do |format|
                format.html { redirect_to messages_path, notice: 'Message created successfully' }
                format.json { render json: @message, status: :created }
            end
        else
            respond_to do |format|
                format.html { render :new, alert: @message.errors.full_messages.join(', ') }
                format.json { render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity }
            end
        end
    end

    private

    def message_params
        params.require(:message).permit(:content)
    end
end
