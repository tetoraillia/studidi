class CourseModulesController < ApplicationController
    before_action :set_course_module, only: [ :show, :edit, :update, :destroy ]
    before_action :check_instructor, only: [ :new, :create, :edit, :update, :destroy ]

    def index
        @course_modules = CourseModule.all
    end

    def show
        @course_module = CourseModule.find(params[:id])
    end

    def new
        @course_module = CourseModule.new
        @course = Course.find(params[:course_id])
    end

    def create
        @course_module = CourseModule.new(course_module_params)
        if @course_module.save
            redirect_to course_course_modules_path(@course_module), notice: "Course module was successfully created."
        else
            render :new
        end
    end

    def edit
    end

    def update
        if @course_module.update(course_module_params)
            redirect_to course_course_module_path(@course_module), notice: "Course module was successfully updated."
        else
            render :edit
        end
    end

    def destroy
        @course_module.destroy
        redirect_to course_path(@course), notice: "Course module was successfully destroyed."
    end

    private

    def set_course_module
        @course_module = CourseModule.find(params[:id])
    end

    def check_instructor
        @course = Course.find(params[:course_id])
        unless @course.instructor == current_user
            redirect_to course_url, notice: "You are not authorized to perform this action."
        end
    end

    def course_module_params
        params.require(:course_module).permit(:title, :course_id, :position)
    end
end
