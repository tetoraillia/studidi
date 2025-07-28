# app/queries/teacher_report_query.rb
class TeacherReportQuery
  def initialize(teacher_id)
    @teacher_id = teacher_id
  end

  def call
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
            100.0 * COUNT(DISTINCT CONCAT(r.user_id, '-', r.responseable_id))
            / (COUNT(DISTINCT l.id) * COUNT(DISTINCT e.user_id)),
            2
          )
        END AS average_completion_percentage,
        COUNT(DISTINCT r.id) AS total_responses
      FROM courses c
      LEFT JOIN enrollments e ON e.course_id = c.id
      LEFT JOIN topics t ON t.course_id = c.id
      LEFT JOIN lessons l ON l.topic_id = t.id
      LEFT JOIN responses r ON r.responseable_type = 'Lesson' AND r.responseable_id = l.id AND r.user_id = e.user_id
      LEFT JOIN marks m ON m.response_id = r.id
      WHERE c.instructor_id = ?
      GROUP BY c.id, c.title
      ORDER BY c.title;
    SQL

    sanitized_sql = ActiveRecord::Base.send(:sanitize_sql_array, [ sql, @teacher_id ])
    ActiveRecord::Base.connection.execute(sanitized_sql)
  end
end
