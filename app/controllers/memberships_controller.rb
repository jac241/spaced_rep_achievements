class MembershipsController < ApplicationController
  before_action :authenticate_user!

  def create
    results = CreateMembershipService.call(params: params, new_member: current_user)

    respond_to do |format|
      results.on(:created) do |membership|
        format.js { redirect_to membership.group, notice: "Successfully joined group!", turbolinks: "advance" }
      end

      results.on(:invalid_params) do |membership|
        format.js do
          redirect_to groups_path, notice: "Unable to join group: #{membership.errors.full_messages.join(",")}."
        end
      end

      results.on(:trying_to_join_private_group) do |message|
        format.js { redirect_to groups_path, notice: message }
      end
    end
  end

  def destroy
    results = DestroyMembershipService.call(params: params, approving_user: current_user)
    respond_to do |format|
      results.on(:destroyed) do |membership|
        format.js { redirect_to destroy_redirect_path(membership), notice: destroy_notice(membership) }
      end

      results.on(:last_admin_cannot_leave) do |membership|
        format.js { redirect_to membership.group, notice: "Groups have to have at least one admin. Find another, then you'll be able to leave." }
      end
    end
  end

  def update
    membership = Membership.find(params[:id])

    authorize membership

    respond_to do |format|
      if membership.update(update_params)
        format.js { redirect_to membership.group, notice: "#{membership.member.username}'s membership was updated." }
      else
        format.js { redirect_to membership.group, notice: "Unable to update membership: #{membership.errors.full_messages.join(",")}" }
      end
    end
  end

  private

  def destroy_redirect_path(membership)
    if membership.member == current_user
      groups_path
    else
      group_path(membership.group)
    end
  end

  def update_params
    params.require(:membership).permit(:admin)
  end

  def destroy_notice(membership)
    if membership.member == current_user
      "You've successfully left #{membership.group.name}"
    else
      "Removed #{membership.member.username} from the group."
    end
  end
end
