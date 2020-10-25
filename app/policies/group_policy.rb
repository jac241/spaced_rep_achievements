class GroupPolicy < ApplicationPolicy
  def show?
    record.public? || record.members.include?(user)
  end

  def update?
    record.admin?(user)
  end
end
