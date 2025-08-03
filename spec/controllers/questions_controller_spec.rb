require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user, :teacher) }
  let(:course) { create(:course, instructor: user) }
  let(:topic) { create(:topic, course: course, position: 1) }
  let(:lesson) { create(:lesson, topic: topic) }

  describe 'GET #new' do
    before { sign_in user }

    it 'returns http success' do
      get :new, params: { course_id: course.id, topic_id: topic.id, lesson_id: lesson.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    before { sign_in user }

    it 'creates a new question' do
      expect {
        post :create, params: { course_id: course.id, topic_id: topic.id, lesson_id: lesson.id, question: { title: 'Test Question', content: 'Test content', lesson_id: lesson.id } }
      }.to change(Question, :count).by(1)
    end

    it 'redirects to lesson after creation' do
      post :create, params: { course_id: course.id, topic_id: topic.id, lesson_id: lesson.id, question: { title: 'Test Question', content: 'Test content', lesson_id: lesson.id } }
      expect(response).to redirect_to(course_topic_lesson_path(course, topic, lesson))
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in user }
    let!(:question) { create(:question, lesson: lesson) }

    it 'deletes the question' do
      expect {
        delete :destroy, params: { course_id: course.id, topic_id: topic.id, lesson_id: lesson.id, id: question.id }
      }.to change(Question, :count).by(-1)
    end

    it 'redirects to lesson after deletion' do
      delete :destroy, params: { course_id: course.id, topic_id: topic.id, lesson_id: lesson.id, id: question.id }
      expect(response).to redirect_to(course_topic_lesson_path(course, topic, lesson))
    end
  end
end
