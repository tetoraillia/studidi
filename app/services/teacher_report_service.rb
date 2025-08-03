class TeacherReportService
  Report = Struct.new(
    :course_id,
    :course_title,
    :total_students,
    :total_lessons,
    :average_mark,
    :average_completion_percentage,
    :total_responses
  )

  def initialize(teacher_id)
    @teacher_id = teacher_id
  end

  def reports
    rows = TeacherReportQuery.new(@teacher_id).call
    rows.map do |row|
      Report.new(
        row["course_id"],
        row["course_title"],
        row["total_students"]&.to_i,
        row["total_lessons"]&.to_i,
        row["average_mark"]&.to_f&.round(2),
        row["average_completion_percentage"]&.to_f,
        row["total_responses"]&.to_i
      )
    end
  end
end
