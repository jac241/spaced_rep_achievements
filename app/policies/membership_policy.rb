class MembershipPolicy < ApplicationPolicy
  def create?
    if record.public?
      true
    else
      record.admin?(user)
    end
  end
end
