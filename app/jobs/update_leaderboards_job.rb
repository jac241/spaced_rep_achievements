class UpdateLeaderboardsJob < ApplicationJob
  queue_as :default

  def perform
    Family.all.each do |family|
      Leaderboard.timeframes.each do |timeframe|
        leaderboard = Leaderboard.calculate(
          family: family,
          timeframe: timeframe,
          force_cache: true
        )

        LiveLeaderboardsChannel.broadcast_to(
          leaderboard.channel,
          {
            html: LeaderboardsController.render(
              partial: 'leaderboards/leaderboard',
              locals: {
                leaderboard: LeaderboardDecorator.new(leaderboard),
                bust_cache: true,
              }
            )
          }
        )
      end
    end
  end
end
