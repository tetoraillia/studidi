require 'rails_helper'

RSpec.describe "Topics", type: :request do
  let(:user) { create(:user, :teacher) }
  let(:course) { create(:course, instructor: user) }
  let(:topic) { create(:topic, course: course) }

  describe 'GET #index' do
    before { sign_in user }

    it 'returns http success' do
      get course_topics_path(course)
      expect(response).to have_http_status(:success)
    end

    it 'lists all topics' do
      topics = create_list(:topic, 3, course: course)
      get course_topics_path(course)
      topics.each do |topic|
        expect(response.body).to include(topic.title)
      end
    end
  end

  describe 'GET #show' do
    before { sign_in user }

    it 'returns http success' do
      get course_topic_path(course, topic)
      expect(response).to have_http_status(:success)
    end

    it 'displays topic information' do
      get course_topic_path(course, topic)
      expect(response.body).to include(topic.title)
    end

    it 'lists topic lessons' do
      lessons = create_list(:lesson, 2, topic: topic)
      get course_topic_path(course, topic)
      lessons.each do |lesson|
        expect(response.body).to include(lesson.title)
      end
    end
  end

  describe 'GET #new' do
    before { sign_in user }

    it 'returns http success' do
      sign_in user
      get new_course_topic_path(course)
      expect(response).to have_http_status(:success)
    end

    it 'renders the new topic form' do
      sign_in user
      get new_course_topic_path(course)
      expect(response.body).to include('Topic')
      expect(response.body).to include('Create Topic')
    end
  end

  describe 'POST #create' do
    before { sign_in user }

    context 'with valid params' do
      let(:valid_params) { attributes_for(:topic, course_id: course.id) }

      it 'creates a new topic' do
        sign_in user
        expect {
          post course_topics_path(course), params: { topic: valid_params }
        }.to change(Topic, :count).by(1)
      end

      it 'redirects to course topics' do
        sign_in user
        post course_topics_path(course), params: { topic: valid_params }
        expect(response).to redirect_to(course_topics_path(course))
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { topic: { title: '' } } }

      it 'does not create a new topic' do
        sign_in user
        expect {
          post course_topics_path(course), params: { topic: invalid_params[:topic] }
        }.to_not change(Topic, :count)
      end

      it 'renders the new template' do
        sign_in user
        post course_topics_path(course), params: { topic: invalid_params[:topic] }
        expect(response).to redirect_to(new_course_topic_path(course))
      end
    end
  end

  describe 'GET #edit' do
    before { sign_in user }

    it 'returns http success' do
      sign_in user
      get edit_course_topic_path(course, topic)
      expect(response).to have_http_status(:success)
    end

    it 'renders the edit form' do
      sign_in user
      get edit_course_topic_path(course, topic)
      expect(response.body).to include(topic.title)
    end
  end

  describe 'PUT #update' do
    before { sign_in user }

    context 'with valid params' do
      let(:new_title) { 'New Title' }
      let(:valid_params) { { topic: { title: new_title } } }

      it 'updates the topic' do
        sign_in user
        put course_topic_path(course, topic), params: { topic: valid_params[:topic] }
        topic.reload
        expect(topic.title).to eq(new_title)
      end

      it 'redirects to course topics' do
        sign_in user
        put course_topic_path(course, topic), params: { topic: valid_params[:topic] }
        expect(response).to redirect_to(course_topics_path(course))
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { topic: { title: '' } } }

      it 'does not update the topic' do
        sign_in user
        original_title = topic.title
        put course_topic_path(course, topic), params: { topic: invalid_params[:topic] }
        topic.reload
        expect(topic.title).to eq(original_title)
      end

      it 'renders the edit template' do
        sign_in user
        put course_topic_path(course, topic), params: { topic: invalid_params[:topic] }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in user }

    it 'destroys the topic' do
      sign_in user
      topic_to_destroy = create(:topic, course: course)
      expect {
        delete course_topic_path(course, topic_to_destroy)
      }.to change(Topic, :count).by(-1)
    end

    it 'redirects to course topics' do
      sign_in user
      topic_to_destroy = create(:topic, course: course)
      delete course_topic_path(course, topic_to_destroy)
      expect(response).to redirect_to(course_topics_path(course))
    end
  end

  describe 'authorization' do
    let(:other_user) { create(:user, :teacher) }

    before { sign_in other_user }

    it 'redirects if user is not course instructor' do
      other_user = create(:user, :teacher)
      sign_in other_user
      get edit_course_topic_path(course, topic)
      expect(response).to redirect_to(root_path)
    end
  end
end
