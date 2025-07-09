class InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course
  before_action :authorize_teacher!, only: [:new, :create]

  def new
    @invitation = Invitation.new
  end

  def create
    result = Invitations::InvitationCreator.new(
      current_user: current_user,
      email: invitation_params[:email],
      course: @course
    ).call

    if result.success?
      redirect_to course_path(@course), notice: "Invitation sent."
    else
      @invitation = Invitation.new(email: invitation_params[:email])
      flash.now[:alert] = result.message || "Failed to send invitation."
      render :new
    end
  end

  def accept
    invitation = Invitation.find_by(token: params[:id])
    course = invitation&.course

    result = Invitations::InvitationAcceptor.new(
      invitation:,
      current_user:,
      course:
    ).call

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
    unless current_user.teacher? && @course.instructor == current_user
      redirect_to course_path(@course), alert: "You are not authorized to invite to this course."
    end
  end

  def invitation_params
    params.require(:invitation).permit(:email)
  end
end
