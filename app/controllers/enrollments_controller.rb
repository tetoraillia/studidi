class EnrollmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course

  def create
    if current_user.student?
      if !@course.public
        redirect_to @course, alert: "You can only enroll in public courses. Please ask the instructor for an invitation."
        return
      end
      enrollment = Enrollment.find_or_initialize_by(user: current_user, course: @course)
      if enrollment.persisted?
        redirect_to @course, notice: "You are already enrolled in this course."
      else
        enrollment.enrolled_at = Time.current
        if enrollment.save
          redirect_to @course, notice: "Successfully enrolled in the course."
        else
          redirect_to @course, alert: "Could not enroll in the course."
        end
      end
    else
      redirect_to @course, alert: "Only students can enroll in courses."
    end
  end

  def destroy
    enrollment = Enrollment.find_by(user: current_user, course: @course)
    if enrollment
      enrollment.destroy
      redirect_to @course, notice: "You have left the course."
    else
      redirect_to @course, alert: "You are not enrolled in this course."
    end
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end
end
