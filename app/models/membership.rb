class Membership < ApplicationRecord
  belongs_to :group, touch: true
  belongs_to :member, class_name: "User", touch: true

  validates :member, uniqueness: { scope: :group, message: "already part of this group" }
end
