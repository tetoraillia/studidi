require 'rails_helper'

RSpec.describe Invitations::AcceptInvitation do
  let(:user) { create(:user) }
  let(:course) { create(:course) }
  let(:invitation) { create(:invitation, course: course) }
  let(:context) { Interactor::Context.new(invitation: invitation, current_user: user, course: course) }

  subject { Invitations::AcceptInvitation.call(context) }

  describe '.call' do
    context 'when the context is valid and invitation is valid' do
      it 'enrolls the user in the course' do
        expect { subject }.to change(Enrollment, :count).by(1)
      end

      it 'marks the invitation as accepted' do
        subject
        invitation.reload
        expect(invitation.status).to eq("accepted")
      end

      it 'succeeds' do
        expect(subject).to be_a(Interactor::Context)
        expect(subject.success?).to be true
      end

      it 'attaches the invitation to the context' do
        expect(subject.invitation).to eq(invitation)
      end
    end

    context 'when the context is invalid' do
      let(:context) { Interactor::Context.new(invitation: nil, current_user: nil, course: nil) }
      subject { Invitations::AcceptInvitation.call(context) }

      it 'fails' do
        expect(subject).to be_a(Interactor::Context)
        expect(subject.success?).to be false
        expect(subject.error).to eq("Invalid context: missing required parameters")
      end

      it 'does not enroll the user' do
        expect { subject }.to_not change(Enrollment, :count)
      end
    end

    context 'when the invitation is invalid' do
      let(:invitation) { create(:invitation, course: course, status: 'accepted') }
      let(:context) { Interactor::Context.new(invitation: invitation, current_user: user, course: course) }
      subject { Invitations::AcceptInvitation.call(context) }

      it 'fails' do
        expect(subject).to be_a(Interactor::Context)
        expect(subject.success?).to be false
        expect(subject.error).to include("Invalid or expired invitation.")
      end

      it 'does not enroll the user' do
        expect { subject }.to_not change(Enrollment, :count)
      end
    end

    context 'when the user is not signed in' do
      let(:context) { Interactor::Context.new(invitation: invitation, current_user: nil, course: course) }
      subject { Invitations::AcceptInvitation.call(context) }

      it 'fails' do
        expect(subject).to be_a(Interactor::Context)
        expect(subject.success?).to be false
        expect(subject.error).to eq("Invalid context: missing required parameters")
      end

      it 'does not enroll the user' do
        expect { subject }.to_not change(Enrollment, :count)
      end
    end

    context 'when the user is already enrolled' do
      before { create(:enrollment, user: user, course: course) }
      let(:context) { Interactor::Context.new(invitation: invitation, current_user: user, course: course) }
      subject { Invitations::AcceptInvitation.call(context) }

      it 'fails' do
        expect(subject).to be_a(Interactor::Context)
        expect(subject.success?).to be false
        expect(subject.error).to include("You are already enrolled in this course.")
      end

      it 'does not enroll the user' do
        expect { subject }.to_not change(Enrollment, :count)
      end
    end
  end
end
