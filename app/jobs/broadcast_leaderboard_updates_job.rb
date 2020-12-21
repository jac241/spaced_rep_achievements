class BroadcastLeaderboardUpdatesJob < ApplicationJob
  def perform(entries:, medal_statistics:)
    entries.each do |entry|
      Rails.logger.info entry.reified_leaderboard.channel
      RealtimeLeaderboardsChannel.broadcast_to(
        entry.reified_leaderboard.channel,
        {
          type: "api/receiveJsonApiData",
          payload: EntrySerializer.new([ entry ]).to_hash
        }
      )
    end
  end
end
