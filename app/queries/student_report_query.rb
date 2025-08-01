class StudentReportQuery < BaseReportQuery
  def call
    sql = <<-SQL
      SELECT
        course_id,
        course_title,
        course_ends_at,
        COUNT(DISTINCT lesson_id) AS total_lessons,
        COUNT(DISTINCT CASE WHEN response_id IS NOT NULL THEN lesson_id END) AS lessons_completed,
        ROUND(AVG(mark_value)::numeric, 2) AS average_mark,
        CASE
          WHEN COUNT(DISTINCT lesson_id) = 0 THEN 0
          ELSE ROUND(
            100.0 * COUNT(DISTINCT CASE WHEN r.id IS NOT NULL OR qr.id IS NOT NULL THEN l.id END) /#{' '}
                    COUNT(DISTINCT l.id),
            2
          )
        END AS completion_percentage,
        COUNT(m.id) AS marks_received
      FROM courses c
      INNER JOIN enrollments e ON e.course_id = c.id AND e.user_id = ?
      LEFT JOIN topics t ON t.course_id = c.id
      LEFT JOIN lessons l ON l.topic_id = t.id
      LEFT JOIN questions q ON q.lesson_id = l.id
      LEFT JOIN responses r ON r.responseable_type = 'Lesson' AND r.responseable_id = l.id AND r.user_id = ?
      LEFT JOIN responses qr ON qr.responseable_type = 'Question' AND qr.responseable_id = q.id AND qr.user_id = ?
      LEFT JOIN marks m ON (m.response_id = r.id OR m.response_id = qr.id)

      FROM #{BaseReportQuery.base_subquery}
      WHERE student_id = ?
      GROUP BY course_id, course_title, course_ends_at
      ORDER BY course_title;
    SQL

    exec_query(sql, @id)
  end
end
