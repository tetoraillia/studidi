class TopicsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_course, only: [ :new, :create, :edit, :update, :destroy, :index, :show ]
  before_action :set_topic, only: [ :show, :edit, :update, :destroy ]

  def index
    @topics = Topic.for_course(@course.id).ordered.page(params[:page]).per(10)
  end

  def show
    @topic = Topic.find(params[:id])
    authorize @topic
    @lessons = @topic.lessons.order(:position).page(params[:page]).per(10)
  end

  def new
    @topic = Topic.new(course: @course)
    authorize @topic
  end

  def create
    result = Topics::CreateTopic.call(params: topic_params)

    if result.success?
      authorize result.topic
      redirect_to course_topics_path(@course), notice: "Topic was successfully created."
    else
      @topic = Topic.new(topic_params)
      redirect_to new_course_topic_path(@course), alert: "Error creating topic: #{result.error}"
    end
  end

  def edit
    authorize @topic
  end

  def update
    authorize @topic
    result = Topics::UpdateTopic.call(id: @topic.id, params: topic_params)

    if result.success?
      redirect_to course_topics_path(@course), notice: "Topic was successfully updated."
    else
      @topic.assign_attributes(topic_params)
      flash[:alert] = result.error
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @topic
    @topic.destroy
    redirect_to course_topics_path(@course), notice: "Topic was successfully destroyed."
  end

    private

      def set_topic
        @topic = Topic.find(params[:id])
      end

      def set_course
        @course = Course.find(params[:course_id])
      end

      def topic_params
        params.require(:topic).permit(:title, :course_id, :position)
      end
end
