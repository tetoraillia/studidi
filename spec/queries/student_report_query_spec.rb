require 'rails_helper'

RSpec.describe StudentReportQuery, type: :query do
  describe '#call' do
    let!(:student) { create(:user, role: :student) }
    let!(:course) { create(:course) }
    let!(:enrollment) { create(:enrollment, user: student, course: course) }
    let!(:topic) { create(:topic, course: course) }
    let!(:lessons) { create_list(:lesson, 3, topic: topic) }

    context 'when student has responses and marks' do
      let!(:response1) { create(:response, user: student, lesson: lessons[0]) }
      let!(:response2) { create(:response, user: student, lesson: lessons[1]) }
      let!(:mark1) { create(:mark, response: response1, value: 80) }
      let!(:mark2) { create(:mark, response: response2, value: 90) }
      let!(:quiz_mark) { create(:mark, lesson: lessons[2], user: student, value: 70) }

      it 'returns the correct report data' do
        report = StudentReportQuery.new(student.id).call
        result = report.first

        expect(report.count).to eq(1)
        expect(result['course_id']).to eq(course.id)
        expect(result['course_title']).to eq(course.title)
        expect(result['total_lessons']).to eq(3)
        expect(result['lessons_completed']).to eq(2)
        expect(result['average_mark'].to_f).to eq(80.0)
        expect(result['completion_percentage'].to_f).to eq(66.67)
        expect(result['marks_received']).to eq(3)
      end
    end

    context 'when student has no responses' do
      it 'returns zero for completion and average mark' do
        report = StudentReportQuery.new(student.id).call
        result = report.first

        expect(report.count).to eq(1)
        expect(result['lessons_completed']).to eq(0)
        expect(result['average_mark']).to be_nil
        expect(result['completion_percentage'].to_f).to eq(0.0)
        expect(result['marks_received']).to eq(0)
      end
    end

    context 'when course has no lessons' do
      let!(:course_without_lessons) { create(:course) }
      let!(:enrollment_without_lessons) { create(:enrollment, user: student, course: course_without_lessons) }

      it 'returns zero for lesson-related fields' do
        report = StudentReportQuery.new(student.id).call
        result = report.find { |r| r['course_id'] == course_without_lessons.id }

        expect(result['total_lessons']).to eq(0)
        expect(result['lessons_completed']).to eq(0)
        expect(result['completion_percentage'].to_f).to eq(0.0)
      end
    end

    context 'when a different student exists' do
      let!(:other_student) { create(:user, role: :student) }
      let!(:other_enrollment) { create(:enrollment, user: other_student, course: course) }

      it 'only returns data for the specified student' do
        report = StudentReportQuery.new(student.id).call
        expect(report.count).to eq(1)

        other_report = StudentReportQuery.new(other_student.id).call
        expect(other_report.count).to eq(1)
      end
    end
  end
end
