class ApproveMembershipService
  include FlexibleService

  def call(params:, approving_user:)
    request = MembershipRequest.find(params[:membership_request_id])

    Pundit.authorize(approving_user, request.group, :update?)

    MembershipRequest.transaction do
      Membership.create!(
        group: request.group,
        member: request.user,
        admin: false,
      )

      request.destroy!

      success(:approved, request)
    end
  end
end
