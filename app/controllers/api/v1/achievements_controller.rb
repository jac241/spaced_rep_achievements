module Api
  module V1
    class AchievementsController < ApiController
      before_action :auth_by_token!

      def create
        result = CreateAchievementService.call(
          create_params: create_params,
          user: current_token_user
        )

        result.on(:created) do |achievement|
          render json: achievement, status: :created
        end
        result.on(:invalid_params) do |errors|
          render json: errors, status: :unprocessable_entity
        end
      end

      private

      def create_params
        params.require(:achievement).permit(
          :client_db_id, :client_medal_id, :client_deck_id, :client_earned_at,
          :client_uuid
        )
      end
    end
  end
end
