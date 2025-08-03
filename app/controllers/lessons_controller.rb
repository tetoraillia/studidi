class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lesson, only: [ :show, :edit, :update, :destroy, :submit_quiz_answers]
  before_action :set_course_data, only: [ :new, :create, :edit, :update, :destroy, :select_lesson_type, :show, :submit_quiz_answers]

  def select_lesson_type
  end

  def show
    authorize @lesson
    @user = current_user
    @questions = @lesson.questions
    @user_responses = Response.for_questions(@questions).for_user(current_user)
    @user_mark = Mark.for_user(current_user).for_lesson(@lesson).first
    @lesson_responses = Response.for_lesson(@lesson)
    @responses = Response.for_lesson_and_questions(@lesson).includes(:user, :mark).order(created_at: :desc)
    @response = Response.new
    @user_response = Response.for_lesson(@lesson).for_user(current_user).first
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

  def submit_quiz_answers
    Responses::SubmitQuizAnswers.call(
      lesson: @lesson,
      user: current_user,
      params: params,
      topic: @topic,
      course: @course
    )
    redirect_to course_topic_lesson_path(@course, @topic, @lesson)
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
