require 'rails_helper'

RSpec.describe CoursePolicy do
  let(:teacher) { create(:user, role: 'teacher') }
  let(:student) { create(:user, role: 'student') }
  let(:guest)   { nil }
  let(:course)  { create(:course, instructor: teacher) }
  let(:another_teacher) { create(:user, role: 'teacher') }

  describe "#show?" do
    it "allows anyone to view a course" do
      expect(CoursePolicy.new(guest, course).show?).to eq(true)
      expect(CoursePolicy.new(student, course).show?).to eq(true)
      expect(CoursePolicy.new(teacher, course).show?).to eq(true)
    end
  end

  describe "#create?" do
    it "allows teacher to create course" do
      expect(CoursePolicy.new(teacher, Course.new).create?).to eq(true)
    end

    it "denies student and guest" do
      expect(CoursePolicy.new(student, Course.new).create?).to eq(false)
      expect(CoursePolicy.new(guest, Course.new).create?).to eq(nil)
    end
  end

  describe "#update?" do
    it "allows instructor to update course" do
      expect(CoursePolicy.new(teacher, course).update?).to eq(true)
    end

    it "denies others" do
      expect(CoursePolicy.new(another_teacher, course).update?).to eq(false)
      expect(CoursePolicy.new(student, course).update?).to eq(false)
    end
  end
end
