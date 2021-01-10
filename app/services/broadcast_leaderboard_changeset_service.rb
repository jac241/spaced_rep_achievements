class BroadcastLeaderboardChangesetService
  include FlexibleService

  def call(entries:, medal_statistics:)
      entries
        .group_by(&:reified_leaderboard)
        .each do |leaderboard, grouped_entries|
          RealtimeLeaderboardsChannel.broadcast_to(
            leaderboard.channel,
            {
              type: "api/receiveJsonApiData",
              payload: EntrySerializer.new(
                grouped_entries,
                EntrySerializer::TYPICAL_OPTIONS_FOR_BROADCAST
              ).to_hash
            }
          )
      end

      medal_statistics
        .group_by { |m| m.entry.reified_leaderboard }
        .each do |leaderboard, grouped_medal_stats|
          RealtimeLeaderboardsChannel.broadcast_to(
            leaderboard.channel,
            {
              type: "api/receiveJsonApiData",
              payload: MedalStatisticSerializer.new(
                grouped_medal_stats,
                MedalStatisticSerializer::TYPICAL_OPTIONS_FOR_BROADCAST
              ).to_hash
            }
          )
      end
  end
end
