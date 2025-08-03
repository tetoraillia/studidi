require 'rails_helper'

RSpec.describe MarksController, type: :controller do
  let(:user) { create(:user) }
  let(:course) { create(:course) }
  let(:topic) { create(:topic, course: course) }
  let(:lesson) { create(:lesson, topic: topic) }
  let(:user_response) { create(:response, responseable: lesson, user: user, content: "Response content") }
  let!(:mark) { create(:mark, lesson: lesson, user: user, response: user_response) }

  before do
    sign_in user
    allow(controller).to receive(:authorize).and_return(true)
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a mark and redirects with notice' do
        expect {
          post :create, params: {
            course_id: course.id, topic_id: topic.id, lesson_id: lesson.id,
            mark: { value: 5, comment: 'Good', response_id: user_response.id }
          }
        }.to change(Mark, :count).by(1)
        expect(response).to redirect_to(course_topic_lesson_path(course, topic, lesson))
        expect(flash[:notice]).to eq('Your mark was set successfully.')
      end
    end

    context 'with blank response_id' do
      it 'redirects without creating mark' do
        expect {
          post :create, params: {
            course_id: course.id, topic_id: topic.id, lesson_id: lesson.id,
            mark: { value: 5, comment: 'Good', response_id: nil }
          }
        }.not_to change(Mark, :count)
        expect(response).to redirect_to(course_topic_lesson_path(course, topic, lesson))
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'updates the mark and redirects' do
        patch :update, params: {
          course_id: course.id, topic_id: topic.id, lesson_id: lesson.id, id: mark.id,
          mark: { value: 4, comment: 'Updated' }
        }
        expect(response).to redirect_to(course_topic_lesson_path(course, topic, lesson))
        expect(flash[:notice]).to eq('Mark was successfully updated.')
        mark.reload
        expect(mark.value).to eq 4
        expect(mark.comment).to eq 'Updated'
      end
    end
  end
end
