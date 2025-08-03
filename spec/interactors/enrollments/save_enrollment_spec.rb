require 'rails_helper'

RSpec.describe Enrollments::SaveEnrollment do
  describe '.call' do
    let(:user) { create(:user) }
    let(:course) { create(:course, title: 'Valid Title', public: true) }
    let(:enrollment) { build(:enrollment, user: user, course: course) }

    subject { described_class.call(user: user, course: course) }

    context 'when not already enrolled' do
      it 'creates enrollment and succeeds' do
        result = subject
        expect(result).to be_success
        expect(result.enrollment).to be_persisted
        expect(result.message).to eq("Successfully enrolled in the course.")
      end
    end

    context 'when already enrolled' do
      let!(:enrollment) { create(:enrollment, user: user, course: course) }

      it 'does not create duplicate and returns already enrolled message' do
        result = subject
        expect(result).to be_success
        expect(result.message).to eq("You are already enrolled in this course.")
      end
    end

    context 'when enrollment cannot be saved' do
      before do
        allow_any_instance_of(Enrollment).to receive(:save).and_return(false)
      end

      it 'fails with error' do
        result = subject
        expect(result).to be_failure
        expect(result.error).to eq("Could not enroll in the course.")
      end
    end
  end
end
