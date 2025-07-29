class ApplicationNotifier < Noticed::Event
  deliver_by :action_cable,
        stream: -> { "notifications_#{recipient.id}" },
        message: -> { params[:message] },
        url: -> { params[:url] },
        id: -> { notification.id },
        type: -> { params[:type] }
end
