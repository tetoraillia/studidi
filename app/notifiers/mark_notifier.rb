# To deliver this notification:
#
# MarkNotifier.with(record: @post, message: "New post").deliver(User.all)

class MarkNotifier < ApplicationNotifier
  recipients ->{ params[:recipient] }

  deliver_by :database
  deliver_by :action_cable,
            stream: -> { "notifications_#{recipient.id}" },
            message: -> { params[:message] },
            url: -> { params[:url] },
            id: -> { notification.id }

  required_param :message
  required_param :url

  def message
    params[:message]
  end

  def url
    params[:url]
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
