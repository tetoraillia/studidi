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
    enrollment = Enrollment.for_user_and_course(current_user, @course).first
    if enrollment
      enrollment.destroy
      redirect_to @course, notice: "You have left the course."
    else
      redirect_to @course, alert: "You are not enrolled in this course."
    end
  end

  def kick
    enrollment = Enrollment.find_by(id: params[:id], course_id: params[:course_id])

    if enrollment
      authorize enrollment, :destroy?
      enrollment.destroy
      redirect_to @course, notice: "Student has been removed from the course."
    else
      redirect_to @course, alert: "Enrollment not found."
    end
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end
end
