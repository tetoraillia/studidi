module Base
  class BaseReportQuery
    BASE_QUERY = <<-SQL
      SELECT
        c.id AS course_id,
        c.title AS course_title,
        c.ends_at AS course_ends_at,
        e.user_id AS student_id,
        l.id AS lesson_id,
        r.id AS response_id,
        r.user_id AS responder_id,
        m.value AS mark_value,
        c.instructor_id AS teacher_id
      FROM courses c
      LEFT JOIN enrollments e ON e.course_id = c.id
      LEFT JOIN topics t ON t.course_id = c.id
      LEFT JOIN lessons l ON l.topic_id = t.id
      LEFT JOIN responses r ON r.lesson_id = l.id AND r.user_id = e.user_id
      LEFT JOIN marks m ON m.response_id = r.id
    SQL

    def self.base_subquery
      "(#{BASE_QUERY}) base"
    end
  end
end
