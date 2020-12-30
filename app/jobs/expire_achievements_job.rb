class ExpireAchievementsJob < ApplicationJob
  queue_as :realtime_leaderboard

  def perform
    entries_cache = Expiration.cache_for_entries
    medal_stats_cache = Expiration.cache_for_medal_statistics

    ApplicationRecord.transaction do
      ReifiedLeaderboard.find_each.flat_map do |leaderboard|
        expirations =
          Expiration
            .expired_for_leaderboard(leaderboard)
            .find_each
            .map { |exp| exp.expire(entries_cache, medal_stats_cache) }

        expirations.each(&:destroy!)
        entries_cache.values.each(&:save!)
        medal_stats_cache.values.each(&:save!)
      end
    end

    BroadcastLeaderboardChangesetService.call(
      entries: entries_cache.values,
      medal_statistics: medal_stats_cache.values,
    )
  end
end
