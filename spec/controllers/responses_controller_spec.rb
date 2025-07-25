require 'rails_helper'

RSpec.describe ResponsesController, type: :controller do
  routes { Rails.application.routes }

  let(:student) { create(:user, :student) }
  let(:teacher) { create(:user, :teacher) }
  let(:course) { create(:course) }
  let(:topic) { create(:topic, course: course) }
  let(:lesson) { create(:lesson, topic: topic) }
  let(:valid_attributes) { attributes_for(:response, lesson_id: lesson.id, user_id: student.id) }

  describe 'GET #index' do
    context 'as a student' do
      before do
        sign_in student
        get :index, params: { user_id: student.id }
      end

      it 'assigns @user' do
        expect(assigns(:user)).to eq(student)
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end

    context 'as a teacher' do
      before do
        sign_in teacher
        get :index, params: { user_id: teacher.id }
      end

      it 'assigns @teacher_reports' do
        expect(assigns(:teacher_reports)).not_to be_nil
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'POST #create' do
    before { sign_in student }

    let(:nested_params) do
      {
        course_id: course.id,
        topic_id: topic.id,
        lesson_id: lesson.id
      }
    end

    context 'with valid params and lesson open' do
      before do
        allow(Lessons::NoEditAfterLessonEnds).to receive(:call).and_return(double(success?: true))
        allow(Responses::CreateResponseWithMark).to receive(:call).and_return(double(success?: true))
      end

      it 'redirects to lesson page with notice' do
        post :create, params: nested_params.merge(response: valid_attributes)
        expect(response).to redirect_to(course_topic_lesson_path(course, topic, lesson))
        expect(flash[:notice]).to be_present
      end
    end

    context 'when lesson editing is closed' do
      before do
        allow(Lessons::NoEditAfterLessonEnds).to receive(:call).and_return(double(success?: false, error: 'Lesson closed'))
      end

      it 'renders lessons/show with alert' do
        post :create, params: nested_params.merge(response: valid_attributes)
        expect(response).to render_template('lessons/show')
        expect(flash.now[:alert]).to eq('Lesson closed')
      end
    end

    context 'when response creation fails' do
      before do
        allow(Lessons::NoEditAfterLessonEnds).to receive(:call).and_return(double(success?: true))
        allow(Responses::CreateResponseWithMark).to receive(:call).and_return(double(success?: false, error: 'Invalid'))
      end

      it 'redirects to lesson page with alert' do
        post :create, params: nested_params.merge(response: valid_attributes)
        expect(response).to redirect_to(course_topic_lesson_path(course, topic, lesson))
        expect(flash[:alert]).to eq('Invalid')
      end
    end
  end
end
