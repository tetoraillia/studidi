class CoursesController < ApplicationController
    before_action :set_course, only: [ :show, :edit, :update, :destroy ]
    before_action :authenticate_user!, except: [ :index, :show ]
    before_action :check_instructor, only: [ :edit, :update, :destroy ]

    def index
        @courses = Course.ordered.page(params[:page]).per(10)
    end

    def show
        @topics = Topic.where(course_id: params[:id])
    end

    def new
        @course = Course.new
    end

    def create
        result = Courses::CreateCourse.call(
            params: course_params,
            current_user: current_user
        )

        if result.success?
            redirect_to course_url(result.course), notice: "Course was successfully created."
        else
            @course = Course.new(course_params)
            render :new
        end
    end

    def edit
    end

    def update
        result = Courses::UpdateCourse.call(
            id: @course.id,
            params: course_params,
            current_user: current_user
        )
        if result.success?
            redirect_to @course, notice: "Course was successfully updated."
        else
            render :edit
        end
    end

    def destroy
        @course.destroy
        redirect_to courses_url, notice: "Course was successfully destroyed."
    end

    def invite
        @course = Course.find(params[:id])
        redirect_to new_course_invitation_path(@course)
    end

    private

    def set_course
        @course = Course.find(params[:id])
    end

    def course_params
        params.require(:course).permit(:title, :description, :instructor_id, :public)
    end

    def check_instructor
        result = AccessChecker::CourseAccessChecker.call(
            course: @course,
            current_user: current_user
        )
        unless result.success?
            redirect_to courses_url, notice: "You are not an owner of this course."
        end
    end
end
