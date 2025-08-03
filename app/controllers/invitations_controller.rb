class InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course

  def new
    @invitation = Invitation.new(course: @course)
    authorize @invitation
  end

  def create
    result = Invitations::CreateInvitation.call(
      params: invitation_params,
      course: @course,
      current_user: current_user
    )
    authorize result.invitation

    if result.success?
      redirect_to course_path(@course), notice: "Invitation sent."
    else
      @invitation = Invitation.new(email: invitation_params[:email])
      redirect_to new_course_invitation_path(@course), alert: "Error sending invitation: #{result.error}"
    end
  end

  def accept
    @invitation = Invitation.find_by(token: params[:id])
    authorize @invitation

    result = Invitations::AcceptInvitation.call(
      invitation: @invitation,
      current_user: current_user,
      course: @invitation&.course
    )

    if result.success?
      redirect_to course_path(@course), notice: "You have joined the course."
    elsif result.error_code == :not_signed_in
      redirect_to new_user_session_path, alert: result.message
    else
      redirect_to root_path, alert: result.message
    end
  end

  private

    def set_course
      if params[:course_id]
        @course = Course.find(params[:course_id])
      elsif params[:id]
        @invitation = Invitation.find_by(token: params[:id])
        @course = @invitation&.course
      end
    end

    def invitation_params
      params.require(:invitation).permit(:email)
    end
end
