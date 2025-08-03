require 'rails_helper'

RSpec.describe Marks::CreateMark, type: :interactor do
  let(:user) { create(:user) }
  let(:lesson) { create(:lesson) }
  let(:response) { create(:response, responseable: lesson, user: user) }
  let(:params) { { value: 5, comment: 'Great work', response_id: response.id } }

  subject(:context) { described_class.call(user: user, lesson: lesson, response: response, params: params) }

  context 'with valid params' do
    it 'creates a mark' do
      expect { context }.to change(Mark, :count).by(1)
      expect(context).to be_success
      expect(context.mark).to be_a(Mark)
      expect(context.mark.value).to eq 5
      expect(context.mark.comment).to eq 'Great work'
      expect(context.mark.response).to eq response
    end
  end

  context 'with missing lesson' do
    subject(:context) { described_class.call(user: user, lesson: nil, params: params) }
    it 'fails with error' do
      expect(context).to be_failure
      expect(context.error || context.message).to be_present
    end
  end

  context 'with invalid params' do
    let(:params) { { value: nil, comment: '' } }
    it 'does not create a mark and fails' do
      expect { context }.not_to change(Mark, :count)
      expect(context).to be_failure
      expect(context.error).to be_present
    end
  end
end
