class Group < ApplicationRecord
  validates :name, presence: true
  validates :description, length: { maximum: 140 }
  validates_uniqueness_of :name

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships

  has_many :membership_requests, dependent: :destroy
  has_many :requesting_users, through: :membership_requests, source: :user

  def admins
    members.joins(:memberships).where(memberships: { admin: true }).uniq
  end

  def admin?(user)
    admins.include?(user)
  end
end
