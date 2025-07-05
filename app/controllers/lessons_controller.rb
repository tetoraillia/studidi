class LessonsController < ApplicationController
    before_action :set_lesson, only: [ :show, :edit, :update, :destroy ]

    def index
        @lessons = Lesson.all
    end

    def show
    end

    def new
        @lesson = Lesson.new
        @course_module = CourseModule.find(params[:course_module_id])
        @course = Course.find(params[:course_id])
    end

    def create
        @lesson = Lesson.new(lesson_params)
        if @lesson.save
            redirect_to course_course_module_lessons_url, notice: "Lesson was successfully created."
        else
            render :new
        end
    end

    def edit
        @course = @lesson.course_module.course
@course_module = @lesson.course_module
    end

    def update
        if @lesson.update(lesson_params)
            redirect_to course_course_module_lessons_url, notice: "Lesson was successfully updated."
        else
            render :edit
        end
    end

    def destroy
        @lesson.destroy
        redirect_to course_course_module_lessons_url, notice: "Lesson was successfully destroyed."
    end

    private

    def set_lesson
        @lesson = Lesson.find(params[:id])
    end

    def lesson_params
        params.require(:lesson).permit(:title, :content, :content_type, :course_module_id, :position)
    end
end
