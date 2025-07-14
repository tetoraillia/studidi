class CoursePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if @user&.teacher?
        scope.all
      else
        scope.where(public: true)
      end
    end
  end

  def show?
    true
  end

  def create?
    user&.teacher?
  end

  def update?
    user.present? && record.instructor_id == user.id
  end

  def destroy?
    update?
  end

  def invite?
    update?
  end
end
