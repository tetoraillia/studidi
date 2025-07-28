class ResponsesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lesson, only: [ :create ]
  before_action :no_edit_after_lesson_ends, only: [ :create ]

  def index
    @user = User.find(current_user.id)

    if current_user.student?
      reports = StudentReportService.new(current_user.id).reports
      @student_reports = Kaminari.paginate_array(reports).page(params[:reports_page]).per(10)

      base_responses = Response
        .where(user: @user, responseable_type: "Lesson")
        .joins("INNER JOIN lessons ON lessons.id = responses.responseable_id")
        .includes(responseable: { topic: :course }, mark: :user)

      @responses = base_responses
        .order(created_at: :desc)
        .page(params[:responses_page]).per(10)
    elsif current_user.teacher?
      reports = TeacherReportService.new(current_user.id).reports
      @teacher_reports = Kaminari.paginate_array(reports).page(params[:reports_page]).per(10)
    end
  end

  def create
    Rails.logger.info "[DEBUG] Incoming params: #{params.inspect}"
    result = Responses::CreateResponseWithMark.call(
        lesson: @lesson,
        user: current_user,
        params: response_params
    )
    Rails.logger.info "[DEBUG] Interactor result: #{result.inspect}"

    if result.success?
      redirect_to course_topic_lesson_path(@lesson.topic.course, @lesson.topic, @lesson), notice: "Response submitted!"
    else
      Rails.logger.error "[DEBUG] Interactor error: #{result.error}"
      flash.now[:alert] = result.error
      @course = @lesson.topic.course
      @topic = @lesson.topic
      @user = current_user
      @response = @lesson.responses.new(user: current_user)
      @responses = @lesson.responses
      @user_response = @lesson.responses.find_by(user: current_user)
      @mark = Mark.new(lesson: @lesson)
      render "lessons/show", status: :unprocessable_entity
    end
  end

    private

      def no_edit_after_lesson_ends
        result = Lessons::NoEditAfterLessonEnds.call(lesson: @lesson)

        if result.success?
          true
        else
          @user = current_user
          @response = @lesson.responses.new(user: current_user)
          @responses = @lesson.responses
          @user_response = @lesson.responses.find_by(user: current_user)
          @mark = Mark.new(lesson: @lesson)

          flash.now[:alert] = result.error
          render "lessons/show", status: :unprocessable_entity
        end
      end

      def set_lesson
        @lesson = Lesson.find(params[:lesson_id])
      end

      def response_params
        params.require(:response).permit(:content, :responseable_type, :responseable_id)
      end
end
