class MarksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_parent_objects, only: [ :create, :update ]
  before_action :set_mark, only: [ :edit, :update ]

  def create
    @user = current_user

    if params[:mark][:response_id].blank?
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
      params: mark_params,
      current_user: current_user
    )

    if result.success?
      redirect_to course_topic_lesson_path(@course, @topic, @lesson),
                  notice: "Mark was successfully updated."
    else
      @mark = result.mark || Mark.find(params[:id])
      flash.now[:alert] = "Failed to update mark: #{result.error}"
      render :edit, status: :unprocessable_entity
    end
  end

    private

      def set_mark
        @mark = Mark.find(params[:id])
        authorize @mark
      end

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
