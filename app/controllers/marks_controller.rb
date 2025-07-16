class MarksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_parent_objects, only: [ :create ]

    def create
        @user = current_user

        if params[:mark][:response_id].blank?
            flash.now[:alert] = "Response not found"
            redirect_to course_topic_lesson_path(@course, @topic, @lesson)
            return
        end

        @response = Response.find(params[:mark][:response_id])

        result = Marks::CreateMark.call(
            lesson: @lesson,
            user: @user,
            response: @response,
            params: mark_params
        )

        if result.success?
            redirect_to course_topic_lesson_path(@course, @topic, @lesson), notice: "Your mark was set successfully."
        else
            redirect_to course_topic_lesson_path(@course, @topic, @lesson), alert: "Failed to submit mark: #{result.error}"
        end
    end

    def edit
        @mark = Mark.find(params[:id])
    end

    def update
        result = Marks::UpdateMark.call(
            id: params[:id],
            params: mark_params
        )

        if result.success?
            redirect_to course_topic_lesson_path(@course, @topic, @lesson), notice: "Your mark was updated successfully."
        else
            flash.now[:alert] = "Failed to update mark: #{result.error}"
            render "lessons/show", status: :unprocessable_entity
        end
    end

    private

    def set_parent_objects
        @course = Course.find(params[:course_id])
        @topic = @course.topics.find(params[:topic_id])
        @lesson = @topic.lessons.find(params[:lesson_id])
    end

    def mark_params
        params.require(:mark).permit(:value, :comment, :response_id)
    end

    def response_params
        params.require(:mark).permit(:value, :response)
    end
end
