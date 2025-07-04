class CoursesController < ApplicationController
    before_action :set_course, only: [ :show, :edit, :update, :destroy ]
    before_action :authenticate_user!, except: [ :index, :show ]
    before_action :check_instructor, only: [ :edit, :update, :destroy ]

    def index
        @courses = Course.all
    end

    def show
    end

    def new
        @course = Course.new
    end

    def create
        @course = Course.new(course_params)
        if @course.save
            redirect_to @course, notice: "Course was successfully created."
        else
            render :new
        end
    end

    def edit
    end

    def update
        if @course.update(course_params)
            redirect_to @course, notice: "Course was successfully updated."
        else
            render :edit
        end
    end

    def destroy
        @course.destroy
        redirect_to courses_url, notice: "Course was successfully destroyed."
    end

    private

    def set_course
        @course = Course.find(params[:id])
    end

    def course_params
        params.require(:course).permit(:title, :description, :instructor_id)
    end

    def check_instructor
        unless current_user == @course.instructor
            redirect_to courses_url, notice: "You are not authorized to perform this action."
        end
    end
end
