require 'rails_helper'

RSpec.describe LessonPolicy do
  let(:instructor) { create(:user, role: 'teacher') }
  let(:other_teacher) { create(:user, role: 'teacher') }
  let(:student) { create(:user, role: 'student') }
  let(:course) { create(:course, instructor: instructor) }
  let(:topic) { create(:topic, course: course) }
  let(:lesson) { create(:lesson, topic: topic) }

  describe "#show?, #index?" do
    it "allows all users" do
      expect(described_class.new(nil, lesson).show?).to eq(true)
      expect(described_class.new(student, lesson).show?).to eq(true)
      expect(described_class.new(instructor, lesson).show?).to eq(true)
    end
  end

  describe "#create?, #edit?, #update?, #destroy?" do
    it "allows course instructor" do
      expect(described_class.new(instructor, lesson).create?).to eq(true)
      expect(described_class.new(instructor, lesson).edit?).to eq(true)
      expect(described_class.new(instructor, lesson).update?).to eq(true)
      expect(described_class.new(instructor, lesson).destroy?).to eq(true)
    end

    it "denies others" do
      expect(described_class.new(student, lesson).create?).to eq(false)
      expect(described_class.new(other_teacher, lesson).create?).to eq(false)
    end
  end
end
