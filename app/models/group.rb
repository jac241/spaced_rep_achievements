class Group < ApplicationRecord
  validates :name, presence: true
  validates :description, length: { maximum: 140 }
  validates_uniqueness_of :name

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships

  def admins
    members.joins(:memberships).where(memberships: { admin: true }).uniq
  end
end
