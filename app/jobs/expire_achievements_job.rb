class ExpireAchievementsJob < ApplicationJob
  queue_as :realtime_leaderboard

  def perform
    entries_cache = Expiration.cache_for_entries
    medal_stats_cache = Expiration.cache_for_medal_statistics

    ReifiedLeaderboard.find_each do |leaderboard|
      ApplicationRecord.transaction do
        expirations =
          Expiration
            .expired_for_leaderboard(leaderboard)

        bm = Benchmark.measure do
          expirations.find_each { |exp| exp.expire(entries_cache, medal_stats_cache) }
        end
        Rails.logger.info("Time to expire records: #{1000 * bm.real}ms")

        bm = Benchmark.measure do
          expirations.delete_all
        end
        Rails.logger.info("Time to delete_all expirations: #{1000 * bm.real}ms")

        bm = Benchmark.measure do
          entries_cache.values.each(&:save!)
        end
        Rails.logger.info("Time to save entries: #{1000 * bm.real}ms")

        bm = Benchmark.measure do
          medal_stats_cache.values.each(&:save!)
        end
        Rails.logger.info("Time to save medal stats: #{1000 * bm.real}ms")
      end
    end

    BroadcastLeaderboardChangesetService.call(
      entries: entries_cache.values,
      medal_statistics: medal_stats_cache.values,
    )
  end
end
