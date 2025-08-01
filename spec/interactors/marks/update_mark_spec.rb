require 'rails_helper'

RSpec.describe Marks::UpdateMark, type: :interactor do
  let(:user) { create(:user) }
  let(:lesson) { create(:lesson) }
  let(:response) { create(:response, responseable: lesson, user: user) }
  let!(:mark) { create(:mark, response: response, lesson: lesson, user: user) }
  let(:params) { { value: 4, comment: 'Updated' } }

  let(:context) {
    Marks::UpdateMark.call(
      id: mark.id,
      params: { value: 3, comment: "Updated" },
      current_user: user
    )
  }

  context 'with valid params' do
    it 'updates the mark' do
      expect { context }.not_to change(Mark, :count)
      expect(context).to be_success
      expect(context.mark.value).to eq 3
      expect(context.mark.comment).to eq 'Updated'
    end
  end

  context 'when mark not found' do
    subject(:context) { described_class.call(id: 0, params: params, current_user: user) }
    it 'fails with error' do
      expect(context).to be_failure
      expect(context.error).to eq 'Mark not found'
    end
  end
end
