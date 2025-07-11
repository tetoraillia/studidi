class TopicsController < ApplicationController
    before_action :authenticate_user!, except: [ :index, :show ]
    before_action :set_course, only: [ :new, :create, :edit, :update, :destroy, :index ]
    before_action :set_topic, only: [ :show, :edit, :update, :destroy ]
    before_action :check_instructor, only: [ :new, :create, :edit, :update, :destroy ]

    def index
        @topics = Topic.for_course(@course.id).ordered.page(params[:page]).per(10)
    end

    def show
        @lessons = @topic.lessons.ordered.page(params[:page]).per(10)
    end

    def new
        @topic = Topic.new
    end

    def create
        result = Topics::CreateTopic.call(params: topic_params)
        if result.success?
            redirect_to course_topics_path(@course), notice: "Topic was successfully created."
        else
            @topic = Topic.new(topic_params)
            flash[:alert] = result.error
            render :new
        end
    end

    def edit
    end

    def update
        result = Topics::UpdateTopic.call(id: @topic.id, params: topic_params)
        if result.success?
            redirect_to course_topics_path(@course), notice: "Topic was successfully updated."
        else
            @topic = Topic.new(topic_params)
            flash[:alert] = result.error
            render :edit
        end
    end

    def destroy
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

    def check_instructor
        result = Topics::CheckInstructor.call(course: @course, user: current_user)
        unless result.success?
            redirect_to course_topics_url(@course), alert: result.error
        end
    end

    def topic_params
        params.require(:topic).permit(:title, :course_id, :position)
    end
end
