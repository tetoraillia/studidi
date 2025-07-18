# To deliver this notification:
#
# InvitationNotifier.with(record: @post, message: "New post").deliver(User.all)

class InvitationNotifier < ApplicationNotifier
  deliver_by :action_cable, format: :to_action_cable, message: -> { params[:message] }

  def to_action_cable
    {
      message: params[:message],
      url: params[:url]
    }
  end
  # Add your delivery methods
  #
  # deliver_by :email do |config|
  #   config.mailer = "UserMailer"
  #   config.method = "new_post"
  # end
  #
  # bulk_deliver_by :slack do |config|
  #   config.url = -> { Rails.application.credentials.slack_webhook_url }
  # end
  #
  # deliver_by :custom do |config|
  #   config.class = "MyDeliveryMethod"
  # end

  # Add required params
  #
  # required_param :message
end
