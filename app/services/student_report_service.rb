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
    sql = <<-SQL
      SELECT
        c.id AS course_id,
        c.title AS course_title,
        c.ends_at AS course_ends_at,
        COUNT(DISTINCT l.id) AS total_lessons,
        COUNT(DISTINCT CASE WHEN r.id IS NOT NULL THEN l.id END) AS lessons_completed,
        ROUND(AVG(m.value)::numeric, 2) AS average_mark,
        CASE
          WHEN COUNT(DISTINCT l.id) = 0 THEN 0
          ELSE ROUND(
            100.0 * COUNT(DISTINCT CASE WHEN r.id IS NOT NULL THEN l.id END) / COUNT(DISTINCT l.id),
            2
          )
        END AS completion_percentage,
        COUNT(m.id) AS marks_received
      FROM courses c
      INNER JOIN enrollments e ON e.course_id = c.id AND e.user_id = ?
      LEFT JOIN topics t ON t.course_id = c.id
      LEFT JOIN lessons l ON l.topic_id = t.id
      LEFT JOIN responses r ON r.lesson_id = l.id AND r.user_id = ?
      LEFT JOIN marks m ON m.response_id = r.id
      GROUP BY c.id, c.title, c.ends_at
      ORDER BY c.title;
    SQL

    sanitized_sql = ActiveRecord::Base.send(:sanitize_sql_array, [ sql, @student_id, @student_id ])
    results = ActiveRecord::Base.connection.execute(sanitized_sql)

    results.map do |row|
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
