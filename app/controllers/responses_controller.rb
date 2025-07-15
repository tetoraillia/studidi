class ResponsesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_lesson, only: [ :create ]

    def index
        @user = User.find(current_user.id)
        @responses = Response.where(user: @user)
    end

    def create
       result = Responses::CreateResponseWithMark.call(
           lesson: @lesson,
           user: current_user,
           params: response_params
       )

       if result.success?
           redirect_to course_topic_lesson_path(@lesson.topic.course, @lesson.topic, @lesson), notice: "Response and mark were successfully created."
       else
           redirect_to course_topic_lesson_path(@lesson.topic.course, @lesson.topic, @lesson), alert: result.error
       end
    end

    private

    def set_lesson
        @lesson = Lesson.find(params[:lesson_id])
    end

    def response_params
        params.require(:response).permit(:content, :mark_id, :lesson_id, :user_id)
    end
end
