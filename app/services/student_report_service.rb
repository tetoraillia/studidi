class StudentReportService
  Report = Struct.new(
    :course_id,
    :course_title,
    :course_ends_at,
    :total_lessons,
    :lessons_completed,
    :average_mark,
    :completion_percentage,
    :marks_received
  )

  def initialize(student_id)
    @student_id = student_id
  end

  def reports
    rows = StudentReportQuery.new(@student_id).call

    rows.map do |row|
      Report.new(
        row["course_id"],
        row["course_title"],
        row["course_ends_at"],
        row["total_lessons"]&.to_i,
        row["lessons_completed"]&.to_i,
        row["average_mark"]&.to_f&.round(2),
        row["completion_percentage"]&.to_f,
        row["marks_received"]&.to_i
      )
    end
  end
end
