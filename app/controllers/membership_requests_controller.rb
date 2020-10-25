class MembershipRequestsController < ApplicationController
  def create
    results = CreateMembershipRequestService.call(
      params: params,
      user: current_user
    )
    respond_to do |format|
      results.on(:created) do |request|
        format.js { redirect_to groups_path, notice: "Requested to join \"#{request.group.name}\"" }
      end
      results.on(:already_requested_to_join) do
        format.js { redirect_to groups_path, notice: "You've already requested to join this group." }
      end
    end
  end
end
