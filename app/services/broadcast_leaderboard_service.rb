class BroadcastLeaderboardService
  include FlexibleService

  def call(leaderboard)
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
