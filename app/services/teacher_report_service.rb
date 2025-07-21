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

  # Returns array of Report structs
  def reports
    sql = <<-SQL
      SELECT
        c.id AS course_id,
        c.title AS course_title,
        COUNT(DISTINCT e.user_id) AS total_students,
        COUNT(DISTINCT l.id) AS total_lessons,
        ROUND(AVG(m.value)::numeric, 2) AS average_mark,
        CASE 
          WHEN COUNT(DISTINCT l.id) = 0 OR COUNT(DISTINCT e.user_id) = 0 THEN 0
          ELSE ROUND(
            100.0 * COUNT(DISTINCT CONCAT(r.user_id, '-', r.lesson_id)) 
            / (COUNT(DISTINCT l.id) * COUNT(DISTINCT e.user_id)),
            2
          )
        END AS average_completion_percentage,
        COUNT(DISTINCT r.id) AS total_responses
      FROM courses c
      LEFT JOIN enrollments e ON e.course_id = c.id
      LEFT JOIN topics t ON t.course_id = c.id
      LEFT JOIN lessons l ON l.topic_id = t.id
      LEFT JOIN responses r ON r.lesson_id = l.id AND r.user_id = e.user_id
      LEFT JOIN marks m ON m.response_id = r.id
      WHERE c.instructor_id = #{@teacher_id}
      GROUP BY c.id, c.title
      ORDER BY c.title;
    SQL

    results = ActiveRecord::Base.connection.execute(sql)
    results.map do |row|
      Report.new(
        row['course_id'],
        row['course_title'],
        row['total_students']&.to_i,
        row['total_lessons']&.to_i,
        row['average_mark']&.to_f&.round(2),
        row['average_completion_percentage']&.to_f,
        row['total_responses']&.to_i
      )
    end
  end
end
