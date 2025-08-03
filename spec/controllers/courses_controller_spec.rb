require 'rails_helper'
require 'cgi'

RSpec.describe "Courses", type: :request do
  let(:user) { create(:user, :teacher) }
  let(:course) { create(:course, instructor: user) }

  describe 'GET #index' do
    it 'returns http success' do
      get courses_path
      expect(response).to have_http_status(:success)
    end

    it 'lists all courses' do
      create_list(:course, 3)
      get courses_path
      expect(response.body).to include(Course.first.title)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get course_path(course)
      expect(response).to have_http_status(:success)
    end

    it 'displays course information' do
      get course_path(course)
      expect(response.body).to include(CGI.escapeHTML(course.title))
      expect(response.body).to include(CGI.escapeHTML(course.description))
    end

    it 'lists course topics' do
      topics = create_list(:topic, 2, course: course)
      get course_path(course)
      topics.each do |topic|
        expect(response.body).to include(topic.title)
      end
    end
  end

  describe 'GET #new' do
    before { sign_in user }

    it 'returns http success' do
      sign_in user
      get new_course_path
      expect(response).to have_http_status(:success)
    end

    it 'renders the new course form' do
      sign_in user
      get new_course_path
      expect(response.body).to include('New Course')
    end
  end

  describe 'POST #create' do
    before { sign_in user }

    context 'with valid params' do
      let(:valid_params) { attributes_for(:course) }

      it 'creates a new course' do
        sign_in user
        expect {
          post courses_path, params: { course: valid_params }
        }.to change(Course, :count).by(1)
      end

      it 'redirects to the created course' do
        sign_in user
        post courses_path, params: { course: valid_params }
        expect(response).to redirect_to(Course.last)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { course: { title: '' } } }

      it 'does not create a new course' do
        sign_in user
        expect {
          post courses_path, params: invalid_params
        }.to_not change(Course, :count)
      end

      it 'renders the new template' do
        sign_in user
        post courses_path, params: invalid_params
        expect(response).to redirect_to(new_course_path)
      end
    end
  end

  describe 'GET #edit' do
    before { sign_in user }

    it 'returns http success' do
      sign_in user
      get edit_course_path(course)
      expect(response).to have_http_status(:success)
    end

    it 'renders the edit form' do
      sign_in user
      get edit_course_path(course)
      expect(response.body).to include(course.title)
    end
  end

  describe 'PUT #update' do
    before { sign_in user }

    context 'with valid params' do
      let(:new_title) { 'New Title' }
      let(:valid_params) { { course: { title: new_title } } }

      it 'updates the course' do
        sign_in user
        put course_path(course), params: { course: valid_params[:course] }
        course.reload
        expect(course.title).to eq(new_title)
      end

      it 'redirects to the course' do
        sign_in user
        put course_path(course), params: { course: valid_params[:course] }
        expect(response).to redirect_to(course)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { course: { title: '' } } }

      it 'does not update the course' do
        sign_in user
        original_title = course.title
        put course_path(course), params: { course: invalid_params[:course] }
        course.reload
        expect(course.title).to eq(original_title)
      end

      it 'renders the edit template' do
        sign_in user
        put course_path(course), params: { course: invalid_params[:course] }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in user }

    it 'destroys the course' do
      sign_in user
      course_to_destroy = create(:course, instructor: user)
      expect {
        delete course_path(course_to_destroy)
      }.to change(Course, :count).by(-1)
    end

    it 'redirects to courses list' do
      sign_in user
      course_to_destroy = create(:course, instructor: user)
      delete course_path(course_to_destroy)
      expect(response).to redirect_to(courses_path)
    end
  end

  describe 'GET #invite' do
    before { sign_in user }

    it 'redirects to new invitation path' do
      sign_in user
      get invite_course_path(course)
      expect(response).to redirect_to(new_course_invitation_path(course))
    end
  end
end
