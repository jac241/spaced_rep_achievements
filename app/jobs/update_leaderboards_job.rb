class UpdateLeaderboardsJob < ApplicationJob
  queue_as :default

  def perform
    Family.all.each do |family|
      Leaderboard.timeframes.each do |timeframe|
        leaderboard = Leaderboard.calculate(family: family, timeframe: timeframe)

        LiveLeaderboardsChannel.broadcast_to(
          leaderboard.channel,
          {
            html: ApplicationController.render(
              partial: 'leaderboards/leaderboard',
              locals: { leaderboard: LeaderboardDecorator.new(leaderboard) }
            )
          }
        )
      end
    end
  end
end
