# To deliver this notification:
#
# InvitationNotifier.with(record: @post, message: "New post").deliver(User.all)

class InvitationNotifier < ApplicationNotifier
  deliver_by :action_cable,
          stream: -> { "notifications_#{recipient.id}" },
          message: -> { params[:message] },
          url: -> { params[:url] },
          id: -> { notification.id }
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
