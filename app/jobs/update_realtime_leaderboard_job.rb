class UpdateRealtimeLeaderboardJob < ApplicationJob
  def perform(leaderboard:, data_since:)
    RealtimeLeaderboardsChannel.broadcast_to(
      leaderboard,
      {
        type: "api/receiveJsonApiData",
        payload: leaderboard.serializer.to_hash
      }
    )
  end
end
