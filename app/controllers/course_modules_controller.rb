class CourseModulesController < ApplicationController
    before_action :authenticate_user!, except: [ :index, :show ]
    before_action :set_course, only: [ :new, :create, :edit, :update, :destroy, :index ]
    before_action :set_course_module, only: [ :show, :edit, :update, :destroy ]
    before_action :check_instructor, only: [ :new, :create, :edit, :update, :destroy ]

    def index
        @course_modules = CourseModule.where(course_id: @course.id).order(created_at: :asc).page(params[:page]).per(10)
    end

    def show
        @course_module = CourseModule.find(params[:id])
        @lessons = @course_module.lessons.order(:position).page(params[:page]).per(10)
    end

    def new
        @course_module = CourseModule.new
    end

    def create
        @course_module = CourseModule.new(course_module_params)
        if @course_module.save
            redirect_to course_course_module_path(@course, @course_module), notice: "Course module was successfully created."
        else
            render :new
        end
    end

    def edit
    end

    def update
        if @course_module.update(course_module_params)
            redirect_to course_course_module_path(@course, @course_module), notice: "Course module was successfully updated."
        else
            render :edit
        end
    end

    def destroy
        @course_module.destroy
        redirect_to course_course_modules_path, notice: "Course module was successfully destroyed."
    end

    private

    def set_course_module
        @course_module = CourseModule.find(params[:id])
    end

    def set_course
        @course = Course.find(params[:course_id])
    end

    def check_instructor
        @course ||= if params[:id]
                      CourseModule.find(params[:id]).course
        else
                      Course.find(params[:course_id])
        end

        unless @course.instructor == current_user
          redirect_to course_course_modules_url notice: "You are not an owner of this course."
        end
      end


    def course_module_params
        params.require(:course_module).permit(:title, :course_id, :position)
    end
end
