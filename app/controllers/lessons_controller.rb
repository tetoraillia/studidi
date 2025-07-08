class LessonsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_instructor
    before_action :set_lesson, only: [ :edit, :update, :destroy ]
    before_action :set_course_data, only: [ :new, :create, :edit, :update, :destroy ]

    def select_lesson_type
      @course = Course.find(params[:course_id])
      @course_module = @course.course_modules.find(params[:course_module_id])
    end

    def new
        @lesson = Lesson.new
        @lesson.content_type = params[:content_type]
    end

    def create
        @lesson = Lesson.new(lesson_params)
        if @lesson.save
            redirect_to course_course_module_path(@course, @course_module), notice: "Lesson was successfully created."
        else
            render :new
        end
    end

    def edit
    end

    def update
        if @lesson.update(lesson_params)
            redirect_to course_course_module_path(@course, @course_module), notice: "Lesson was successfully updated."
        else
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
