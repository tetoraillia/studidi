class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def unread_count
    count = current_user.notifications.where(read_at: nil).count
    render json: { unread: count }
  end

  def index
    notifications = current_user.notifications.order(created_at: :desc)

    case params[:filter]
    when "unread"
      @notifications = notifications.where(read_at: nil)
    when "read"
      @notifications = notifications.where.not(read_at: nil)
    else
      @notifications = notifications
    end

    @notifications = @notifications.page(params[:page]).per(10)
  end

  def update
    notification = current_user.notifications.find(params[:id])
    notification.update(read_at: Time.current)
    redirect_back fallback_location: notifications_path
  end
end
