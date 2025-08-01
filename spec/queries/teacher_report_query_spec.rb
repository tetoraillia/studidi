require 'rails_helper'

RSpec.describe TeacherReportQuery, type: :query do
  describe '#call' do
    let!(:teacher) { create(:user, role: :teacher) }
    let!(:course) { create(:course, instructor: teacher) }
    let!(:students) { create_list(:user, 2, role: :student) }
    let!(:enrollments) do
      students.map { |student| create(:enrollment, user: student, course: course) }
    end
    let!(:topic) { create(:topic, course: course) }
    let!(:lessons) { create_list(:lesson, 3, topic: topic) }

    context 'when there is activity in the course' do
      let!(:response1) { create(:response, user: students[0], lesson: lessons[0]) }
      let!(:response2) { create(:response, user: students[0], lesson: lessons[1]) }
      let!(:response3) { create(:response, user: students[1], lesson: lessons[0]) }
      let!(:mark1) { create(:mark, response: response1, value: 80) }
      let!(:mark2) { create(:mark, response: response3, value: 90) }
      let!(:quiz_mark) { create(:mark, lesson: lessons[2], user: students[0], value: 75) }

      it 'returns the correct report data for the teacher' do
        report = TeacherReportQuery.new(teacher.id).call
        result = report.first

        expect(report.count).to eq(1)
        expect(result['course_id']).to eq(course.id)
        expect(result['total_students']).to eq(2)
        expect(result['total_lessons']).to eq(3)
        expect(result['average_mark'].to_f).to eq(81.67)
        expect(result['average_completion_percentage'].to_f).to eq(50)
        expect(result['total_responses']).to eq(3)
      end
    end

    context 'when there are no students' do
      let!(:course_no_students) { create(:course, instructor: teacher) }

      it 'returns zero for student-related fields' do
        report = TeacherReportQuery.new(teacher.id).call
        result = report.find { |r| r['course_id'] == course_no_students.id }

        expect(result['total_students']).to eq(0)
        expect(result['average_completion_percentage'].to_f).to eq(0.0)
        expect(result['total_responses']).to eq(0)
      end
    end

    context 'when a different teacher exists' do
      let!(:other_teacher) { create(:user, role: :teacher) }
      let!(:other_course) { create(:course, instructor: other_teacher) }

      it 'only returns data for the specified teacher' do
        report = TeacherReportQuery.new(teacher.id).call
        expect(report.count).to eq(1)
        expect(report.first['course_id']).to eq(course.id)
      end
    end
  end
end
