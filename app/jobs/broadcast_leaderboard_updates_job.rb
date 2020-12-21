class BroadcastLeaderboardUpdatesJob < ApplicationJob
  def perform(entries:, medal_statistics:)
    entries.each do |entry|
      RealtimeLeaderboardsChannel.broadcast_to(
        entry.reified_leaderboard.channel,
        {
          type: "api/receiveJsonApiData",
          payload: EntrySerializer.new([ entry ], include: [ :user ]).to_hash
        }
      )
    end
  end
end
