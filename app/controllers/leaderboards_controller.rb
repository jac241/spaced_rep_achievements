class LeaderboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    result = CalculateLeadersService.call(
      family_slug: params[:family_id],
      count: 10,
      timeframe: params[:id]
    )

    result.on(:found) do |leaderboard|
      @leaderboard = LeaderboardDecorator.new(leaderboard)
      @families = Family.all
      @timeframes = Leaderboard.timeframes
    end
  end
end
