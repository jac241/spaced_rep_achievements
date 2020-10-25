class CreateMembershipService
  include FlexibleService

  def call(params:, new_member:)
    group = Group.find(params[:group_id])

    if group.public?
      join_group(group, new_member)
    else
      failure(:trying_to_join_private_group, "Must request to join private group")
    end
  end

  private

  def join_group(group, new_member)
    membership = group.memberships.new(member: new_member)

    if membership.save
      success(:created, membership)
    else
      failure(:invalid_params, membership)
    end
  end
end
