require 'rails_helper'

RSpec.describe TopicPolicy do
  let(:instructor) { create(:user, role: 'teacher') }
  let(:other_teacher) { create(:user, role: 'teacher') }
  let(:student) { create(:user, role: 'student') }
  let(:course) { create(:course, instructor: instructor) }
  let(:topic) { create(:topic, course: course) }

  describe "#show?, #index?" do
    it "allows all users" do
      expect(described_class.new(nil, topic).show?).to eq(true)
      expect(described_class.new(student, topic).show?).to eq(true)
      expect(described_class.new(instructor, topic).show?).to eq(true)
    end
  end

  describe "#create?, #edit?, #update?, #destroy?" do
    it "allows instructor of the course" do
      expect(described_class.new(instructor, topic).create?).to eq(true)
      expect(described_class.new(instructor, topic).edit?).to eq(true)
      expect(described_class.new(instructor, topic).update?).to eq(true)
      expect(described_class.new(instructor, topic).destroy?).to eq(true)
    end

    it "denies others" do
      expect(described_class.new(other_teacher, topic).create?).to eq(false)
      expect(described_class.new(student, topic).create?).to eq(false)
    end
  end
end
