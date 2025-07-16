require 'rails_helper'

RSpec.describe InvitationPolicy do
  let(:instructor) { create(:user, role: 'teacher') }
  let(:another_teacher) { create(:user, role: 'teacher') }
  let(:student) { create(:user, role: 'student') }
  let(:course) { create(:course, instructor: instructor) }
  let(:invitation) { create(:invitation, course: course, email: student.email, status: "pending") }

  describe "#new?, #create?" do
    it "allows course instructor" do
      expect(described_class.new(instructor, invitation).new?).to eq(true)
      expect(described_class.new(instructor, invitation).create?).to eq(true)
    end

    it "denies others" do
      expect(described_class.new(another_teacher, invitation).new?).to eq(false)
      expect(described_class.new(student, invitation).new?).to eq(false)
    end
  end
end
