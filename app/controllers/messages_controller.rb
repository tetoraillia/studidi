class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @messages = Message.all.order(created_at: :asc)
    @user = current_user
    respond_to do |format|
      format.html
      format.json do
        render json: @messages, each_serializer: MessageSerializer, include: [:user]
      end
    end
end

  def create
    @message = current_user.messages.build(message_params)
    if @message.save
      render json: @message, serializer: MessageSerializer, include: [:user], status: :created
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
end

    private

      def message_params
        params.require(:message).permit(:content)
      end
end
