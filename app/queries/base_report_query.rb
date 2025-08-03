class BaseReportQuery
  BASE_QUERY = <<-SQL
    SELECT
      c.id AS course_id,
      c.title AS course_title,
      c.ends_at AS course_ends_at,
      e.user_id AS student_id,
      l.id AS lesson_id,
      q.id AS question_id,
      r.id AS lesson_response_id,
      r.user_id AS lesson_responder_id,
      qr.id AS question_response_id,
      qr.user_id AS question_responder_id,
      m.value AS mark_value,
      qm.value AS quiz_mark_value,
      c.instructor_id AS teacher_id
    FROM courses c
    LEFT JOIN enrollments e ON e.course_id = c.id
    LEFT JOIN topics t ON t.course_id = c.id
    LEFT JOIN lessons l ON l.topic_id = t.id
    LEFT JOIN questions q ON q.lesson_id = l.id
    LEFT JOIN responses r ON r.responseable_type = 'Lesson' AND r.responseable_id = l.id AND r.user_id = e.user_id
    LEFT JOIN responses qr ON qr.responseable_type = 'Question' AND qr.responseable_id = q.id AND qr.user_id = e.user_id
    LEFT JOIN marks m ON (m.response_id = r.id OR m.response_id = qr.id)
    LEFT JOIN marks qm ON qm.lesson_id = l.id AND qm.user_id = e.user_id AND qm.response_id IS NULL
  SQL

  def initialize(id)
    @id = id
  end

  def self.base_subquery
    "(#{BASE_QUERY}) base"
  end

  protected

    def exec_query(sql, *params)
      ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array, [sql, *params])
      )
    end
end
