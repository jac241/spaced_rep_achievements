class LeaderboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    result = FindLeaderboardService.call(
      user: current_user,
      maybe_family_slug: params[:family_id],
      maybe_timeframe: params[:id]
    )

    result.on(:found) do |leaderboard|
      @leaderboard = LeaderboardDecorator.new(leaderboard)
      @families = Family.all
      @timeframes = Leaderboard.timeframes
    end
  end
end
