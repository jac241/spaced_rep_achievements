class MembershipsController < ApplicationController
  before_action :authenticate_user!

  def create
    results = CreateMembershipService.call(params: params, new_member: current_user)

    respond_to do |format|
      results.on(:created) do |membership|
        format.js { redirect_to membership.group, notice: "Successfully joined group!" }
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
end
