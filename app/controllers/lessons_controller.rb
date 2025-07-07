class LessonsController < ApplicationController
    before_action :set_course, only: [ :new, :create, :edit, :update, :destroy ]
    before_action :authenticate_user!
    before_action :check_instructor
    before_action :set_lesson, only: [ :edit, :update, :destroy ]

    def new
        @lesson = Lesson.new
        @course_module = CourseModule.find(params[:course_module_id])
        @course = @course_module.course
    end

    def create
        @lesson = Lesson.new(lesson_params)
        if @lesson.save
            @course_module = CourseModule.find(params[:course_module_id])
            @course = @course_module.course
            redirect_to course_course_module_path(@course, @course_module), notice: "Lesson was successfully created."
        else
            @course_module = CourseModule.find(params[:course_module_id])
            @course = @course_module.course
            render :new
        end
    end

    def edit
        @course = @lesson.course_module.course
        @course_module = @lesson.course_module
    end

    def update
        if @lesson.update(lesson_params)
            @course_module = @lesson.course_module
            @course = @course_module.course
            redirect_to course_course_module_path(@course, @course_module), notice: "Lesson was successfully updated."
        else
            @course_module = @lesson.course_module
            @course = @course_module.course
            render :edit
        end
    end

    def destroy
        @lesson.destroy
        redirect_to course_course_module_path, notice: "Lesson was successfully destroyed."
    end

    private

    def set_course
        @course = Course.find(params[:course_id])
    end

    def set_lesson
        @lesson = Lesson.find(params[:id])
    end

    def lesson_params
        params.require(:lesson).permit(:title, :content, :content_type, :course_module_id, :position)
    end

    def check_instructor
        @course ||= if params[:id]
                      Lesson.find(params[:id]).course_module.course
        else
                      Course.find(params[:course_id])
        end

        unless @course.instructor == current_user
          redirect_to course_course_modules_url notice: "You are not an owner of this course."
        end
    end
end
