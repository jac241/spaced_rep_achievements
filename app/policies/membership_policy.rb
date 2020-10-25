class MembershipPolicy < ApplicationPolicy
  def destroy?
    record.member == user || record.group.admin?(user)
  end

  def create?
    if record.public?
      true
    else
      record.admin?(user)
    end
  end
end
