class EnrollmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course

  def create
    result = Enrollments::EnrollStudent.call(user: current_user, course: @course)

    if result.success?
      redirect_to @course, notice: result.message
    else
      redirect_to @course, alert: result.error
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
