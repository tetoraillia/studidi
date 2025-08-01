class StudentReportQuery < BaseReportQuery
  def call
    sql = <<-SQL
      SELECT
        course_id,
        course_title,
        course_ends_at,
        COUNT(DISTINCT lesson_id) AS total_lessons,
        COUNT(DISTINCT CASE WHEN lesson_response_id IS NOT NULL OR question_response_id IS NOT NULL THEN lesson_id END) AS lessons_completed,
        ROUND(AVG(COALESCE(mark_value, quiz_mark_value))::numeric, 2) AS average_mark,
        CASE
          WHEN COUNT(DISTINCT lesson_id) = 0 THEN 0
          ELSE ROUND(
            100.0 * COUNT(DISTINCT CASE WHEN lesson_response_id IS NOT NULL OR question_response_id IS NOT NULL THEN lesson_id END) /#{' '}
                    COUNT(DISTINCT lesson_id),
            2
          )
        END AS completion_percentage,
        COUNT(mark_value) + COUNT(quiz_mark_value) AS marks_received
      FROM #{BaseReportQuery.base_subquery}
      WHERE student_id = ?
      GROUP BY course_id, course_title, course_ends_at
      ORDER BY course_title;
    SQL

    exec_query(sql, @id)
  end
end
