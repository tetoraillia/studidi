class ResponsesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_lesson, only: [ :create ]
    before_action :no_edit_after_lesson_ends, only: [ :create ]

    def index
        @user = User.find(current_user.id)
        @responses = Response.where(user: @user).page(params[:page]).per(10)
        
        if current_user.student?
            @student_reports = StudentReportService.new(current_user.id).reports
        elsif current_user.teacher?
            @teacher_reports = TeacherReportService.new(current_user.id).reports
        end
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

    def no_edit_after_lesson_ends
        result = Lessons::NoEditAfterLessonEnds.call(lesson: @lesson)

        if result.success?
            true
        else
            @user = current_user
            @response = Response.new(lesson: @lesson, user: current_user)
            @responses = Response.where(lesson: @lesson)
            @user_response = Response.find_by(lesson: @lesson, user: current_user)
            @mark = Mark.new(lesson: @lesson)

            flash.now[:alert] = result.error
            render "lessons/show", status: :unprocessable_entity
        end
    end

    def set_lesson
        @lesson = Lesson.find(params[:lesson_id])
    end

    def response_params
        params.require(:response).permit(:content, :mark_id, :lesson_id, :user_id, :attachment)
    end
end
