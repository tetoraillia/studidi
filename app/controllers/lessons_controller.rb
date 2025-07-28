class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lesson, only: [ :show, :edit, :update, :destroy ]
  before_action :set_course_data, only: [ :new, :create, :edit, :update, :destroy, :select_lesson_type, :show ]

  def select_lesson_type
  end

  def show
    authorize @lesson
    @user = current_user
    @response = Response.new(responseable: @lesson, user: current_user)
    @responses = Response.where(responseable: @lesson)
    @user_response = Response.find_by(responseable: @lesson, user: current_user)
    @mark = Mark.new(lesson: @lesson)
    @response_mark = Mark.where(lesson_id: @lesson.id)
  end

  def new
    @lesson = Lesson.new(topic: @topic)
    authorize @lesson
    @lesson.content_type = params[:content_type]
  end

  def create
    result = Lessons::CreateLesson.call(
        params: lesson_params,
        course: @course,
        topic: @topic
    )

    if result.success?
      authorize result.lesson
      redirect_to course_topic_path(@course, @topic), notice: "Lesson was successfully created."
    else
      @lesson = result.lesson || Lesson.new(lesson_params)
      flash.now[:alert] = "Error creating lesson: #{result.error}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @lesson
  end

  def update
    authorize @lesson
    result = Lessons::UpdateLesson.call(
        id: @lesson.id,
        params: lesson_params,
        course: @course,
        topic: @topic
    )

    if result.success?
      redirect_to course_topic_path(@course, @topic), notice: "Lesson was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @lesson
    @lesson.destroy
    redirect_to course_topic_path(@course, @topic), notice: "Lesson was successfully destroyed."
  end

    private

      def set_course_data
        @topic = Topic.find(params[:topic_id])
        @course = Course.find(params[:course_id])
      end

      def set_lesson
        @lesson = Lesson.find(params[:id])
      end

      def lesson_params
        params.require(:lesson).permit(:title, :content, :content_type, :topic_id, :position, :video_url, :student_response_id, :ends_at)
      end
end
