class LeaderboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    result = CalculateLeadersService.call(
      family_slug: params[:id],
      count: 10,
      timeframe: :month
    )

    result.on(:found) do |result|
      @leaderboard = LeaderboardDecorator.new(
        result.leaders, context: {
          family: result.family
        })
    end
  end
end
