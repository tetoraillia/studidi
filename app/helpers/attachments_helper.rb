module AttachmentsHelper
  def render_attachment(attachment)
    return unless attachment.present?

    if attachment.content_type.start_with?("image/")
      image_tag(attachment.url(:thumb))
    elsif attachment.content_type == "application/pdf"
      link_to("View PDF", attachment.url, target: "_blank")
    elsif attachment.content_type.in?(%w[application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document])
      link_to("Download Document", attachment.url, target: "_blank")
    else
      link_to("Download File", attachment.url, target: "_blank")
    end
  end
end
