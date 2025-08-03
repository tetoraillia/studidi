require 'rails_helper'

RSpec.describe Enrollments::CheckCourseAvailability do
  let(:user) { build_stubbed(:user, :student) }

  subject { described_class.call(user: user, course: course) }

  context 'when course is public' do
    let(:course) { build_stubbed(:course, public: true) }

    it 'succeeds' do
      expect(subject).to be_success
    end
  end

  context 'when course is not public' do
    let(:course) { build_stubbed(:course, public: false) }

    it 'fails with error' do
      expect(subject).to be_failure
      expect(subject.error).to eq("This course is not available for enrollment.")
    end
  end
end
