module NotificationsHelper
  NOTIFICATION_BADGE_CLASSES = {
    "Enrollment" => "primary",
    "Invitation" => "warning",
    "Lesson"     => "success",
    "Mark"       => "info",
    "Response"   => "dark"
  }.freeze

  def badge_class_for(notification)
    type = notification.params[:type].to_s.capitalize.presence || "Other"
    NOTIFICATION_BADGE_CLASSES[type] || "secondary"
  end

  def notification_type_label(notification)
    notification.params[:type].to_s.capitalize.presence || "Other"
  end
end
