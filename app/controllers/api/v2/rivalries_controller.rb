module Api
  module V2
    class RivalriesController < Api::V1::ApiController
      before_action :auth_by_token!

      def show
        @reified_leaderboard = Family.friendly.find(params[:id]).reified_leaderboards.find_by_timeframe(:daily)
      end
    end
  end
end
