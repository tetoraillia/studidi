require 'rails_helper'

RSpec.describe TeacherReportService, type: :service do
  describe '#reports' do
    let(:teacher) { create(:user, role: :teacher) }
    let(:service) { described_class.new(teacher.id) }
    let(:query_instance) { instance_double(TeacherReportQuery) }

    before do
      allow(TeacherReportQuery).to receive(:new).with(teacher.id).and_return(query_instance)
    end

    context 'when the query returns data' do
      let(:query_result) do
        [
          {
            'course_id' => 1,
            'course_title' => 'Advanced Ruby',
            'total_students' => 25,
            'total_lessons' => 20,
            'average_mark' => 78.9,
            'average_completion_percentage' => 60.5,
            'total_responses' => 150
          }
        ]
      end

      it 'returns an array of Report structs' do
        allow(query_instance).to receive(:call).and_return(query_result)

        reports = service.reports
        report = reports.first

        expect(reports).to be_an(Array)
        expect(report).to be_a(TeacherReportService::Report)
        expect(report.course_id).to eq(1)
        expect(report.total_students).to eq(25)
        expect(report.average_mark).to eq(78.9)
        expect(report.average_completion_percentage).to eq(60.5)
      end
    end

    context 'when the query returns no data' do
      it 'returns an empty array' do
        allow(query_instance).to receive(:call).and_return([])

        reports = service.reports

        expect(reports).to be_empty
      end
    end
  end
end
