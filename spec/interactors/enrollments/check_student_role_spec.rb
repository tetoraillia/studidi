require 'rails_helper'

RSpec.describe Enrollments::CheckStudentRole do
  let(:course) { build_stubbed(:course) }

  subject { described_class.call(user: user, course: course) }

  context 'when user is a student' do
    let(:user) { build_stubbed(:user, :student) }

    it 'succeeds' do
      expect(subject).to be_success
    end
  end

  context 'when user is not a student' do
    let(:user) { build_stubbed(:user, :teacher) }

    it 'fails with error' do
      expect(subject).to be_failure
      expect(subject.error).to eq("Only students can enroll in courses.")
    end
  end
end
