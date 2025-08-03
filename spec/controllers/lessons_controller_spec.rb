require 'rails_helper'

RSpec.describe "Lessons", type: :request do
  let(:user) { create(:user, :teacher) }
  let(:course) { create(:course, instructor: user) }
  let(:topic) { create(:topic, course: course, position: 1) }
  let(:lesson) { create(:lesson, topic: topic) }

  describe 'GET #select_lesson_type' do
    before { sign_in user }

    it 'returns http success' do
      sign_in user
      get select_lesson_type_course_topic_lessons_path(course, topic)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    before { sign_in user }

    it 'returns http success' do
      sign_in user
      get new_course_topic_lesson_path(course, topic, content_type: 'text')
      expect(response).to have_http_status(:success)
    end

    it 'renders the new lesson form' do
      sign_in user
      get new_course_topic_lesson_path(course, topic, content_type: 'text')
      expect(response.body).to include('Lesson')
      expect(response.body).to include('Create Lesson')
    end

    it 'sets content_type from params' do
      sign_in user
      get new_course_topic_lesson_path(course, topic, content_type: 'video')
      expect(response.body).to include('video')
    end
  end

  describe 'POST #create' do
    before { sign_in user }

    context 'with valid params' do
      let(:valid_params) { attributes_for(:lesson, topic_id: topic.id) }

      it 'creates a new lesson' do
        sign_in user
        expect {
          post course_topic_lessons_path(course, topic), params: { lesson: valid_params }
        }.to change(Lesson, :count).by(1)
      end

      it 'redirects to course topic' do
        sign_in user
        post course_topic_lessons_path(course, topic), params: { lesson: valid_params }
        expect(response).to redirect_to(course_topic_path(course, topic))
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { lesson: { title: '' } } }

      it 'does not create a new lesson' do
        sign_in user
        expect {
          post course_topic_lessons_path(course, topic), params: { lesson: invalid_params[:lesson] }
        }.to_not change(Lesson, :count)
      end

      it 'renders the new template with an unprocessable_entity status' do
        sign_in user
        post course_topic_lessons_path(course, topic), params: { lesson: invalid_params[:lesson] }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #edit' do
    before { sign_in user }

    it 'returns http success' do
      sign_in user
      get edit_course_topic_lesson_path(course, topic, lesson)
      expect(response).to have_http_status(:success)
    end

    it 'renders the edit form' do
      sign_in user
      get edit_course_topic_lesson_path(course, topic, lesson)
      expect(response.body).to include(lesson.title)
    end
  end

  describe 'PUT #update' do
    before { sign_in user }

    context 'with valid params' do
      let(:new_title) { 'New Title' }
      let(:valid_params) { { lesson: { title: new_title } } }

      it 'updates the lesson' do
        sign_in user
        put course_topic_lesson_path(course, topic, lesson), params: { lesson: valid_params[:lesson] }
        lesson.reload
        expect(lesson.title).to eq(new_title)
      end

      it 'redirects to course topic' do
        sign_in user
        put course_topic_lesson_path(course, topic, lesson), params: { lesson: valid_params[:lesson] }
        expect(response).to redirect_to(course_topic_path(course, topic))
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { lesson: { title: '' } } }

      it 'does not update the lesson' do
        original_title = lesson.title
        put course_topic_lesson_path(course, topic, lesson), params: { lesson: invalid_params[:lesson] }
        lesson.reload
        expect(lesson.title).to eq(original_title)
      end

      it 'renders the edit template' do
        sign_in user
        put course_topic_lesson_path(course, topic, lesson), params: { lesson: invalid_params[:lesson] }
        expect(response).to redirect_to(course_topic_path(course, topic))
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in user }
    let!(:lesson_to_destroy) { create(:lesson, topic: topic) }

    it 'destroys the lesson' do
      expect {
        delete course_topic_lesson_path(course, topic, lesson_to_destroy)
      }.to change(Lesson, :count).by(-1)
    end

    it 'redirects to course topic' do
      delete course_topic_lesson_path(course, topic, lesson_to_destroy)
      expect(response).to redirect_to(course_topic_path(course, topic))
    end
  end

  describe 'POST #submit_quiz_answers' do
    before { sign_in user }
    let!(:lesson_to_submit) { create(:lesson, topic: topic) }

    it 'redirects to lesson page after submission' do
      sign_in user
      post submit_quiz_answers_course_topic_lesson_path(course, topic, lesson_to_submit), params: { responses: {} }
      expect(response).to redirect_to(course_topic_lesson_path(course, topic, lesson_to_submit))
    end
  end

  describe 'authorization' do
    let(:other_user) { create(:user, :teacher) }

    before { sign_in other_user }

    it 'redirects if user is not course instructor' do
      get edit_course_topic_lesson_path(course, topic, lesson)
      expect(response).to redirect_to(root_path)
    end
  end
end
