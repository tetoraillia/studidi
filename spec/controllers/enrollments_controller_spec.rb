require 'rails_helper'

RSpec.describe EnrollmentsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:course) { create(:course, title: 'Valid Title', public: true) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe 'POST #create' do
    subject { post :create, params: { course_id: course.id } }

    context 'when user is a student and course is public' do
      it 'enrolls the user and redirects with success notice' do
        subject
        expect(response).to redirect_to(course)
        expect(flash[:notice]).to eq("Successfully enrolled in the course.")
      end
    end

    context 'when user is already enrolled' do
      before { create(:enrollment, user: user, course: course) }

      it 'redirects with already enrolled message' do
        subject
        expect(response).to redirect_to(course)
        expect(flash[:notice]).to eq("You are already enrolled in this course.")
      end
    end

    context 'when user is not a student' do
      let(:user) { create(:user, :teacher) }

      it 'redirects with error' do
        subject
        expect(response).to redirect_to(course)
        expect(flash[:alert]).to eq("Only students can enroll in courses.")
      end
    end

    context 'when course is not public' do
      let(:course) { create(:course, public: false) }

      it 'redirects with error' do
        subject
        expect(response).to redirect_to(course)
        expect(flash[:alert]).to eq("This course is not available for enrollment.")
      end
    end
  end

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { course_id: course.id, id: enrollment_id } }

    context 'when enrolled' do
      let!(:enrollment) { create(:enrollment, user: user, course: course) }
      let(:enrollment_id) { enrollment.id }

      it 'destroys enrollment and redirects with notice' do
        subject
        expect(response).to redirect_to(course)
        expect(flash[:notice]).to eq("You have left the course.")
        expect(Enrollment.where(user: user, course: course)).to be_empty
      end
    end

    context 'when not enrolled' do
      let(:enrollment_id) { 999_999 }

      it 'redirects with alert' do
        subject
        expect(response).to redirect_to(course)
        expect(flash[:alert]).to eq("You are not enrolled in this course.")
      end
    end
  end
end
