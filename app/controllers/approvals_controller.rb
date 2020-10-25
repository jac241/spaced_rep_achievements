class ApprovalsController < ApplicationController
  def create
    results = ApproveMembershipService.call(params: create_params, approving_user: current_user)

    respond_to do |format|
      results.on(:approved) do |request|
        format.js do
          redirect_to group_path(request.group),
            anchor: "membership_requests",
            notice: "Accepted #{request.user.username}'s request to join!"
        end
      end
    end
  end

  private

  def create_params
    params.permit(:membership_request_id)
  end
end
