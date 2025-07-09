class TopicsController < ApplicationController
    before_action :authenticate_user!, except: [ :index, :show ]
    before_action :set_course, only: [ :new, :create, :edit, :update, :destroy, :index ]
    before_action :set_topic, only: [ :show, :edit, :update, :destroy ]
    before_action :check_instructor, only: [ :new, :create, :edit, :update, :destroy ]

    def index
        @topics = Topic.where(course_id: @course.id).order(created_at: :asc).page(params[:page]).per(10)
    end

    def show
        @topic = Topic.find(params[:id])
        @lessons = @topic.lessons.order(:position).page(params[:page]).per(10)
    end

    def new
        @topic = Topic.new
    end

    def create
        result = Topics::TopicCreator.new(topic_params).call
        if result.success?
            redirect_to course_topics_path(@course), notice: "Topic was successfully created."
        else
            @topic = Topic.new(topic_params)
            render :new
        end
    end

    def edit
    end

    def update
        result = Topics::TopicUpdater.new(@topic.id, topic_params).call
        if result.success?
            redirect_to course_topics_path(@course), notice: "Topic was successfully updated."
        else
            @topic = Topic.new(topic_params)
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
        result = AccessChecker::CourseAccessChecker.new(course: @course, user: current_user).call
        unless result.success?
            redirect_to course_topics_url(@course), notice: "You are not an owner of this course."
        end
    end


    def topic_params
        params.require(:topic).permit(:title, :course_id, :position)
    end
end
