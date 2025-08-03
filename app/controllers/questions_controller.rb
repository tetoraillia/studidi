class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course_data, only: [ :new, :create, :destroy ]
  before_action :set_lesson, only: [ :new ]

  def new
    @question = Question.new(lesson: @lesson)
    authorize @question
    2.times { @question.options.build }
  end

  def create
    @question = Question.new(question_params)
    authorize @question
    if @question.save
      redirect_to course_topic_lesson_path(@course, @topic, @lesson)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @question = Question.find(params[:id])
    authorize @question
    @question.destroy
    redirect_to course_topic_lesson_path(@course, @topic, @lesson)
  end

  private

    def set_lesson
      @lesson = Lesson.find(params[:lesson_id])
    end

    def set_course_data
      @course = Course.find(params[:course_id])
      @topic = Topic.find(params[:topic_id])
      @lesson = Lesson.find(params[:lesson_id])
      @user = current_user
    end

    def question_params
      params.require(:question).permit(:title, :content, :lesson_id, options_attributes: [:id, :title, :is_correct, :_destroy])
    end
end
