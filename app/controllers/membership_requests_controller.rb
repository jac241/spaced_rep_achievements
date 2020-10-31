class MembershipRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group

  def new
    @membership_request = @group.membership_requests.new
  end

  def create
    results = CreateMembershipRequestService.call(
      group_id: params[:group_id],
      params: create_params,
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

  private

  def create_params
    params.require(:membership_request).permit(:message)
  end

  def set_group
    @group = Group.find(params[:group_id])
  end
end
