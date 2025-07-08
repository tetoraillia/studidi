class InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course
  before_action :authorize_teacher!

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = @course.invitations.build(invitation_params)
    @invitation.invited_by = current_user
    if @invitation.save
      InvitationMailer.invite_email(@invitation).deliver_later
      redirect_to course_path(@course), notice: "Invitation sent."
    else
      render :new
    end
  end

  def accept
    @invitation = Invitation.find_by(token: params[:id])
    @course = @invitation&.course
    if @invitation && @invitation.status == "pending"
      if user_signed_in?
        unless current_user.enrolled_in?(@course)
          Enrollment.create(user: current_user, course: @course, enrolled_at: Time.current)
        end
        @invitation.update(status: "accepted")
        redirect_to course_path(@course), notice: "You have joined the course."
      else
        redirect_to new_user_session_path, alert: "Please sign in to accept the invitation."
      end
    else
      redirect_to root_path, alert: "Invalid or expired invitation."
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
