class TopicPolicy < ApplicationPolicy
  def show?
    true
  end

  def index?
    true
  end

  def create?
    user&.teacher? && record.course.instructor_id == user.id
  end

  def edit?
    create?
  end

  def update?
    create?
  end

  def destroy?
    update?
  end
end
