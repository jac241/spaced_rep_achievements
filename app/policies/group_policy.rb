class GroupPolicy < ApplicationPolicy
  def show?
    record.public? || record.members.include?(user) || super
  end

  def update?
    record.admin?(user) || super
  end
end
