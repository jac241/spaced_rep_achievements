class MembershipSerializer < ApplicationSerializer
  belongs_to :member, record_type: :user, serializer: UserSerializer
  belongs_to :group
end
