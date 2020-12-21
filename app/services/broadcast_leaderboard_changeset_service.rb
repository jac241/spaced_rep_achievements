class BroadcastLeaderboardChangesetService
  include FlexibleService

  def call(affected_records:)
    affected_records
      .map(&:entry)
      .group_by(&:reified_leaderboard)
      .each do |leaderboard, entries|
      RealtimeLeaderboardsChannel.broadcast_to(
        leaderboard.channel,
        {
          type: "api/receiveJsonApiData",
          payload: EntrySerializer.new(entries, include: [ :user ]).to_hash
        }
      )
    end
  end
end
