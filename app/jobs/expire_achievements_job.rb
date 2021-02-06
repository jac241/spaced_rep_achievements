class ExpireAchievementsJob < ApplicationJob
  queue_as :realtime_leaderboard

  def perform
    ReifiedLeaderboard.find_each do |leaderboard|
      Rails.logger.info("Expiring for leaderboard: #{leaderboard.family.name} #{leaderboard.timeframe}")
      entries_cache, medal_stats_cache = ApplicationRecord.transaction do
        expirations =
          Expiration
            .expired_for_leaderboard(leaderboard)

        affected_entries = Entry
          .includes(:medal_statistics)
          .where(
            reified_leaderboard: leaderboard,
            user_id: Achievement.where(
              id: expirations.pluck(:achievement_id)).distinct.pluck(:user_id)
          )

        entries_cache =
          affected_entries
            .group_by { |e| [e.reified_leaderboard, e.user_id] }
            .transform_values { |v| v.first }

        medal_stats_cache =
          MedalStatistic.where(entry: affected_entries.pluck(:id))
            .group_by { |m| [m.entry, m.medal_id] }
            .transform_values { |v| v.first }

        bm = Benchmark.measure do
          expirations.find_each { |exp| exp.expire(entries_cache, medal_stats_cache) }
        end
        Rails.logger.info("Time to expire records: #{1000 * bm.real}ms")

        expired_count = nil
        bm = Benchmark.measure do
          expired_count = expirations.delete_all
        end
        Rails.logger.info("Number of Expirations: #{expired_count}")
        Rails.logger.info("Time to delete_all expirations: #{1000 * bm.real}ms")

        Rails.logger.info("Number of entries affected: #{entries_cache.size}")
        Rails.logger.info("Number of medal stats affected: #{medal_stats_cache.size}")

        bm = Benchmark.measure do
          entries_cache.values.each(&:save!)
        end
        Rails.logger.info("Time to save entries: #{1000 * bm.real}ms")

        bm = Benchmark.measure do
          medal_stats_cache.values.each(&:save!)
        end
        Rails.logger.info("Time to save medal stats: #{1000 * bm.real}ms")

        [entries_cache, medal_stats_cache]
      end

      BroadcastLeaderboardChangesetService.call(
        entries: entries_cache.values,
        medal_statistics: medal_stats_cache.values,
      )
    end
  end
end
