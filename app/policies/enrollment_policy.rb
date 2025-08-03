class EnrollmentPolicy < ApplicationPolicy
  def destroy?
    user.teacher? && record.course.instructor_id == user.id
  end
end
