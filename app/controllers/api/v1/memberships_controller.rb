module Api
  module V1
    class MembershipsController < ApiController
      before_action :authenticate_user!

      def index
        user_ids =
          ReifiedLeaderboard
          .find(index_params[:reified_leaderboard_id])
          .entries
          .where('score > 0')
          .pluck(:user_id)
        memberships = Membership.where(member_id: user_ids)

        render json: MembershipSerializer.new(memberships)
      end

      private

      def index_params
        params.permit(:reified_leaderboard_id)
      end
    end
  end
end
