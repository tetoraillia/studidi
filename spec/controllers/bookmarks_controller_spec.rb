require 'rails_helper'

RSpec.describe BookmarksController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user, :student) }
  let(:course) { create(:course, public: true) }
  let(:bookmark) { create(:bookmark, user: user, course: course) }

  describe 'GET #index' do
    subject { get :index }

    before do
      sign_in user
      @bookmark = create(:bookmark, user: user, course: course)
    end

    it 'returns a successful response' do
      subject
      expect(response).to be_successful
    end

    it 'assigns @bookmarks' do
      subject
      expect(assigns(:bookmarks)).to eq([ @bookmark ])
    end
  end

  describe 'POST #create' do
    subject { post :create, params: { course_id: course.id } }

    before do
      sign_in user
    end

    context 'when bookmark already exists' do
      before { create(:bookmark, user: user, course: course) }

      it 'shows error message' do
        subject
        expect(response).to redirect_to(course_path(course))
        expect(flash[:alert]).to eq("You have already bookmarked this course")
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:bookmark) { create(:bookmark, user: user, course: course) }

    subject { delete :destroy, params: { id: bookmark.id } }

    before do
      sign_in user
      @bookmark = bookmark
    end

    it 'deletes the bookmark' do
      expect { subject }.to change { Bookmark.count }.by(-1)
      expect(response).to redirect_to(bookmarks_path)
      expect(flash[:notice]).to eq("Course unbookmarked successfully.")
    end
  end
end
