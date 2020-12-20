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

      if current_user.admin?
        @reified_leaderboard = ReifiedLeaderboard.includes(entries: :user).find_by(
          family: leaderboard.family,
          timeframe: leaderboard.timeframe
        )
      end
    end
  end
end
