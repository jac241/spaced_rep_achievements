class MembershipRequest < ApplicationRecord
  belongs_to :user
  belongs_to :group, touch: true
end
