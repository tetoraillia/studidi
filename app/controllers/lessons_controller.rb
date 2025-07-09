class LessonsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_lesson, only: [ :edit, :update, :destroy ]
    before_action :set_course_data, only: [ :new, :create, :edit, :update, :destroy, :select_lesson_type ]
    before_action :authorize_instructor, only: [ :new, :create, :edit, :update, :destroy ]

    def select_lesson_type
    end

    def new
        @lesson = Lesson.new
        @lesson.content_type = params[:content_type]
    end

    def create
        result = Lessons::LessonCreator.new(lesson_params).call
        if result.success?
            redirect_to course_course_module_path(@course, @course_module), notice: "Lesson was successfully created."
        else
            @lesson = Lesson.new(lesson_params)
            render :new
        end
    end

    def edit
    end

    def update
        result = Lessons::LessonUpdater.new(@lesson.id, lesson_params).call
        if result.success?
            redirect_to course_course_module_path(@course, @course_module), notice: "Lesson was successfully updated."
        else
            @lesson = Lesson.new(lesson_params)
            render :edit
        end
    end

    def destroy
        @lesson.destroy
        redirect_to course_course_module_path, notice: "Lesson was successfully destroyed."
    end

    private

    def set_course_data
        @course_module = CourseModule.find(params[:course_module_id])
        @course = Course.find(params[:course_id])
    end

    def set_lesson
        @lesson = Lesson.find(params[:id])
    end

    def lesson_params
        params.require(:lesson).permit(:title, :content, :content_type, :course_module_id, :position, :video_url)
    end

    def authorize_instructor
        result = AccessChecker::CourseAccessChecker.new(course: @course, user: current_user).call
        unless result.success?
            redirect_to course_course_modules_url, notice: "You are not an owner of this course."
        end
    end
end
