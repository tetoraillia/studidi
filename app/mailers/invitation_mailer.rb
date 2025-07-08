class InvitationMailer < ApplicationMailer
  def invite_email(invitation)
    @invitation = invitation
    @course = invitation.course
    @accept_url = accept_course_invitation_url(@course, @invitation)
    mail(to: @invitation.email, subject: "You're invited to join #{@course.title}")
  end
end
