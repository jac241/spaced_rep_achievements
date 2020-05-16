class LeaderboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    result = CalculateLeadersService.call(
      family_slug: params[:family_id],
      count: 10,
      timeframe: :month
    )

    result.on(:found) do |result|
      @leaderboard = LeaderboardDecorator.new(
        result.leaders, context: {
          family: result.family
        })
      @families = result.all_families
      @timeframes = Leaderboards.timeframes
    end
  end
end
