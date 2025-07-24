class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @messages = Message.all.order(created_at: :asc)
    @user = current_user
    respond_to do |format|
      format.html
      format.json do
        render json: @messages.map { |m|
          {
            id: m.id,
            content: m.content,
            user_id: m.user_id,
            user_name: m.user&.first_name || 'Anonymous',
            created_at: m.created_at.strftime("%H:%M")
          }
        }
      end
    end
  end

  def create
    @message = current_user.messages.build(message_params)
    if @message.save
      render json: @message, include: [:user], status: :created
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

    private

      def message_params
        params.require(:message).permit(:content)
      end
end
