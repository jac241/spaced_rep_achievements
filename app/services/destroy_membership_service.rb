class DestroyMembershipService
  include FlexibleService

  def call(params:, approving_user:)
    membership = Membership.find(params[:id])

    Pundit.authorize(approving_user, membership, :destroy?)

    if will_orphan_group?(membership)
      failure(:last_admin_cannot_leave, membership)
    else
      membership.destroy!

      success(:destroyed, membership)
    end
  end

  private

  def will_orphan_group?(membership)
    admins = membership.group.admins

    admins.count == 1 && admins.include?(membership.member)
  end
end
