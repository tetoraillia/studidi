class TeacherReportQuery < BaseReportQuery
  def call
    sql = <<-SQL
      SELECT
        course_id,
        course_title,
        COUNT(DISTINCT student_id) AS total_students,
        COUNT(DISTINCT lesson_id) AS total_lessons,
        ROUND(AVG(mark_value)::numeric, 2) AS average_mark,
        CASE
          WHEN COUNT(DISTINCT student_id) = 0 OR COUNT(DISTINCT lesson_id) = 0 THEN 0
          ELSE ROUND(
            100.0 * COUNT(DISTINCT (lesson_id))
            / (COUNT(DISTINCT student_id) * COUNT(DISTINCT lesson_id)),
            2
          )
        END AS average_completion_percentage,
        COUNT(DISTINCT response_id) AS total_responses
      FROM #{BaseReportQuery.base_subquery}
      WHERE teacher_id = ?
      GROUP BY course_id, course_title
      ORDER BY course_title;
    SQL

    exec_query(sql, @id)
  end
end
