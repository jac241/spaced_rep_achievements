class UpdateRealtimeLeaderboardJob < ApplicationJob
  queue_as :realtime_leaderboard

  def perform(leaderboard:, data_since:, should_use_cache: false)
    logger.info "Retrieving leaderboard updates since: #{data_since}"
    RealtimeLeaderboardsChannel.broadcast_json_to(
      leaderboard,
      payload(leaderboard, data_since, should_use_cache)
    )
  end

  def payload(leaderboard, data_since, should_use_cache)
    # Returns json to use more efficient caching, marshalling large hash
    # object was slow, ~1s.
    meta = { leaderboard_requested: true }
    if should_use_cache
      Rails.cache.fetch("#{leaderboard.cache_key}/realtime_full_json", expires_in: 1.minute) do
        {
          type: "api/receiveJsonApiData",
          payload: leaderboard.serializer(meta: meta.merge({ from_cache: true })).to_hash
        }.to_json
      end
    else
      {
        type: "api/receiveJsonApiData",
        payload: leaderboard.serializer(data_since: data_since, meta: meta).to_hash
      }.to_json
    end
  end
end
