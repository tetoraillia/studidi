class MarkPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.teacher?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end

  def create?
    user.teacher?
  end

  def update?
    user.teacher?
  end

  def edit?
    update?
  end
end
