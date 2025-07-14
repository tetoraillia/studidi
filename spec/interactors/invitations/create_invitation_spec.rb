require 'rails_helper'

RSpec.describe Invitations::CreateInvitation do
  let(:user) { create(:user, :teacher) }
  let(:course) { create(:course, instructor: user) }
  let(:params) { { email: Faker::Internet.email } }
  let(:context) { Interactor::Context.new(params: params, course: course, current_user: user) }

  subject { Invitations::CreateInvitation.call(context) }

  describe '.call' do
    context 'when the context is valid' do
      it 'creates a new invitation' do
        expect { subject }.to change(Invitation, :count).by(1)
      end

      it 'succeeds' do
        expect(subject).to be_a(Interactor::Context)
        expect(subject.success?).to be true
      end

      it 'attaches the invitation to the context' do
        expect(subject.invitation).to be_a(Invitation)
      end
    end

    context 'when the context is invalid' do
      let(:context) { Interactor::Context.new(params: nil, course: nil, current_user: nil) }
      subject { Invitations::CreateInvitation.call(context) }

      it 'fails' do
        expect(subject).to be_a(Interactor::Context)
        expect(subject.success?).to be false
        expect(subject.error).to eq("Invalid context")
      end

      it 'does not create a new invitation' do
        expect { subject }.to_not change(Invitation, :count)
      end
    end
  end
end
