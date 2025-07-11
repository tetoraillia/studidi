require 'rails_helper'

RSpec.describe Enrollments::EnrollStudent do
  let(:user) { create(:user, :student) }
  let(:course) { create(:course, public: true) }

  subject { described_class.call(user: user, course: course) }

  context 'when user is a student and course is public' do
    it 'enrolls a student in a public course' do
      expect(subject).to be_success
      expect(subject.message).to eq("Successfully enrolled in the course.")
    end
  end

  context 'when user is not a student' do
    let(:user) { create(:user, :teacher) }

    it 'fails if user is not a student' do
      expect(subject).to be_failure
      expect(subject.error).to eq("Only students can enroll in courses.")
    end
  end

  context 'when course is not public' do
    let(:course) { create(:course, public: false) }

    it 'fails if course is not public' do
      expect(subject).to be_failure
      expect(subject.error).to eq("This course is not available for enrollment.")
    end
  end
end
