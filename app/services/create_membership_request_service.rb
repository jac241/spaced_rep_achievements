class CreateMembershipRequestService
  include FlexibleService

  def call(params:, user:)
    membership_request = MembershipRequest.create!(
      group: Group.find(params[:group_id]),
      user: user
    )
    success(:created, membership_request)
  rescue ActiveRecord::RecordNotUnique
    failure(:already_requested_to_join)
  end
end
