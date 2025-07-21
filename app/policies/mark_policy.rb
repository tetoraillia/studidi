class MarkPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin? || user.instructor?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end

  def create?
    user.teacher? || user.admin?
  end

  def update?
    user.teacher? || user.admin?
  end

  def edit?
    update?
  end
end
