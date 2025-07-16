require 'rails_helper'

RSpec.describe EnrollmentPolicy do
  let(:instructor) { create(:user, role: 'teacher') }
  let(:another_teacher) { create(:user, role: 'teacher') }
  let(:student) { create(:user, role: 'student') }
  let(:course) { create(:course, instructor: instructor) }
  let(:enrollment) { create(:enrollment, course: course) }

  describe "#destroy?" do
    it "allows course instructor" do
      expect(described_class.new(instructor, enrollment).destroy?).to eq(true)
    end

    it "denies non-instructors" do
      expect(described_class.new(another_teacher, enrollment).destroy?).to eq(false)
      expect(described_class.new(student, enrollment).destroy?).to eq(false)
    end
  end
end
