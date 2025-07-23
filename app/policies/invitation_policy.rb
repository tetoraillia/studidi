class InvitationPolicy < ApplicationPolicy
  def new?
    user&.teacher? && record.course&.instructor_id == user.id
  end

  def create?
    new?
  end

  def accept?
    user.present? && record.email == user.email && record.status == "pending"
  end
end
