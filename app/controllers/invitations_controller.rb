class InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course
  before_action :authorize_teacher!, only: [ :new, :create ]

  def new
    @invitation = Invitation.new
  end

  def create
    result = Invitations::CreateInvitation.call(
      params: invitation_params,
      course: @course,
      current_user: current_user
    )

    if result.success?
      redirect_to course_path(@course), notice: "Invitation sent."
    else
      @invitation = Invitation.new(email: invitation_params[:email])
      flash.now[:alert] = result.message || "Failed to send invitation."
      render :new
    end
  end

  def accept
    @invitation = Invitation.find_by(token: params[:id])

    result = Invitations::AcceptInvitation.call(
      invitation: @invitation,
      current_user: current_user,
      course: @invitation&.course
    )

    if result.success?
      redirect_to course_path(course), notice: "You have joined the course."
    elsif result.error_code == :not_signed_in
      redirect_to new_user_session_path, alert: result.message
    else
      redirect_to root_path, alert: result.message
    end
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def authorize_teacher!
    result = AccessChecker::TeacherAccessChecker.call(
      course: @course,
      current_user: current_user
    )
    unless result.success?
      redirect_to root_path, alert: "You are not authorized to invite to this course."
      return false
    end
    true
  end

  def invitation_params
    params.require(:invitation).permit(:email)
  end
end
