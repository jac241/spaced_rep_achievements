class UpdateRealtimeLeaderboardJob < ApplicationJob
  queue_as :realtime_leaderboard

  def perform(leaderboard:, data_since:, should_use_cache: false)
    logger.info "Retrieving leaderboard updates since: #{data_since}"
    RealtimeLeaderboardsChannel.broadcast_to(
      leaderboard,
      {
        type: "api/receiveJsonApiData",
        payload: payload(leaderboard, data_since, should_use_cache)
      }
    )
  end

  def payload(leaderboard, data_since, should_use_cache)
    meta = { leaderboard_requested: true }
    if should_use_cache
      Rails.cache.fetch("#{leaderboard.cache_key}/realtime_full", expires_in: 1.minute) do
        leaderboard.serializer(meta: meta.merge({ from_cache: true })).to_hash
      end
    else
      leaderboard.serializer(data_since: data_since, meta: meta).to_hash
    end
  end
end
