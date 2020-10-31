class MembershipPolicy < ApplicationPolicy
  def destroy?
    record.member == user || (record.group.admin?(user) && !record.admin?) || super
  end

  def create?
    record.public? || record.admin?(user) || super
  end

  def update?
    record.group.admin?(user) && either_member_is_not_an_admin_or_member_is_themselves || super
  end

  private

  def either_member_is_not_an_admin_or_member_is_themselves
    (!record.admin? || record.member == user)
  end
end
