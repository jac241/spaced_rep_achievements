class CreateMembershipRequestService
  include FlexibleService

  def call(group_id:, params:, user:)
    membership_request = MembershipRequest.create!(
      params.merge(
        group: Group.find(group_id),
        user: user,
      )
    )
    success(:created, membership_request)
  rescue ActiveRecord::RecordNotUnique
    failure(:already_requested_to_join)
  end
end
