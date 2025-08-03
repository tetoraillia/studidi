class CoursesController < ApplicationController
  before_action :set_course, only: [ :show, :edit, :update, :destroy ]
  before_action :authenticate_user!, except: [ :index, :show ]

  def index
    @q = policy_scope(Course).ransack(params[:q])
    @courses = @q.result

    if params.dig(:q, :lessonable).present?
      @courses = @courses.lessonable(true)
    end

    if params.dig(:q, :enrolled).present? && current_user
      @courses = @courses.enrolled(current_user.id)
    end

    if params.dig(:q, :recent).present?
      @courses = @courses.recent
    end

    @courses = @courses.order(created_at: :asc).page(params[:page]).per(10)
  end

  def show
    authorize @course
    @topics = Topic.where(course_id: params[:id])

    # Lesson search (Ransack)
    @lesson_q = @course.lessons.ransack(params[:q])
    @lessons_by_topic = @lesson_q.result.includes(:topic).group_by(&:topic_id)
  end

  def new
    @course = Course.new
  end

  def create
    result = Courses::CreateCourse.call(
        params: course_params,
        current_user: current_user
    )

    if result.success?
      authorize result.course
      redirect_to course_url(result.course), notice: "Course was successfully created."
    else
      @course = result.course
      redirect_to new_course_path, alert: "Error creating course: #{result.error}"
    end
  end

  def edit
    authorize @course
  end

  def update
    authorize @course
    result = Courses::UpdateCourse.call(
        id: @course.id,
        params: course_params,
        current_user: current_user
    )

    if result.success?
      redirect_to @course, notice: "Course was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    authorize @course
    @course.destroy
    redirect_to courses_url, notice: "Course was successfully destroyed."
  end

  def invite
    @course = Course.find(params[:id])
    redirect_to new_course_invitation_path(@course)
  end

    private

      def set_course
        @course = Course.find(params[:id])
      end

      def course_params
        params.require(:course).permit(:title, :description, :instructor_id, :public, :ends_at)
      end
end
