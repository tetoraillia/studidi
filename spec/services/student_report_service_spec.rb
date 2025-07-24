require 'rails_helper'

RSpec.describe StudentReportService, type: :service do
  describe '#reports' do
    let(:student) { create(:user) }
    let(:service) { described_class.new(student.id) }
    let(:query_instance) { instance_double(StudentReportQuery) }

    before do
      allow(StudentReportQuery).to receive(:new).with(student.id).and_return(query_instance)
    end

    context 'when the query returns data' do
      let(:query_result) do
        [
          {
            'course_id' => 1,
            'course_title' => 'Test Course',
            'course_ends_at' => Time.now.iso8601,
            'total_lessons' => 10,
            'lessons_completed' => 5,
            'average_mark' => 85.5,
            'completion_percentage' => 50.0,
            'marks_received' => 4
          }
        ]
      end

      it 'returns an array of Report structs' do
        allow(query_instance).to receive(:call).and_return(query_result)

        reports = service.reports
        report = reports.first

        expect(reports).to be_an(Array)
        expect(report).to be_a(StudentReportService::Report)
        expect(report.course_id).to eq(1)
        expect(report.total_lessons).to eq(10)
        expect(report.average_mark).to eq(85.5)
        expect(report.completion_percentage).to eq(50.0)
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
