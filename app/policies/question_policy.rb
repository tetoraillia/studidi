class QuestionPolicy < ApplicationPolicy
  def new?
    teacher? && record.lesson.questions.count < 20
  end

  def create?
    new?
  end

  def destroy?
    teacher?
  end

  private

    def teacher?
      user&.teacher? && record.lesson.topic.course.instructor_id == user.id
    end
end
