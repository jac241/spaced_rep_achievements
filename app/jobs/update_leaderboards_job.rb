class UpdateLeaderboardsJob < ApplicationJob
  queue_as :default

  def perform(timeframe)
    Family.all.each do |family|
      leaderboard = Leaderboard.calculate(
        family: family,
        timeframe: timeframe.to_sym,
        force_cache: true
      )

      BroadcastLeaderboardService.call(leaderboard)
    end
  end
end
