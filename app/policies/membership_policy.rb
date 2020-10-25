class MembershipPolicy < ApplicationPolicy
  def destroy?
    record.group.admin?(user) && either_member_is_not_an_admin_or_member_is_themselves
  end

  def create?
    if record.public?
      true
    else
      record.admin?(user)
    end
  end

  def update?
    record.group.admin?(user) && either_member_is_not_an_admin_or_member_is_themselves
  end

  private

  def either_member_is_not_an_admin_or_member_is_themselves
    (!record.admin? || record.member == user)
  end
end
