class ExpireAchievementsJob < ApplicationJob
  queue_as :realtime_leaderboard

  def perform
    old_log_level = Rails.logger.level
    begin
      Rails.logger.level = 0 # Debug
      ReifiedLeaderboard.find_each do |leaderboard|
        Rails.logger.info("Expiring for leaderboard: #{leaderboard.family.name} #{leaderboard.timeframe}")
        entries_cache, medal_stats_cache = ApplicationRecord.transaction do
          expirations =
            Expiration
              .expired_for_leaderboard(leaderboard)

          Rails.logger.info("Load affected entries")
          affected_entries = Entry
            .where(
              reified_leaderboard: leaderboard,
              user_id: Achievement.where(
                id: expirations.pluck(:achievement_id)).distinct.pluck(:user_id)
            )

          entries_cache =
            affected_entries
              .group_by { |e| [e.reified_leaderboard_id, e.user_id] }
              .transform_values { |v| v.first }

          Rails.logger.info("Load medal statistics")
          medal_stats_cache =
            MedalStatistic
              .where(entry: affected_entries.pluck(:id))
              .group_by { |ms| [ms.entry_id, ms.medal_id] }
              .transform_values { |v| v.first }

          Rails.logger.info("Do expiration")
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
            entries_cache.values.each { |e| e.save!(validate: false) }
          end
          Rails.logger.info("Time to save entries: #{1000 * bm.real}ms")

          bm = Benchmark.measure do
            medal_stats_cache.values.each { |ms| ms.save!(validate: false) }
          end
          Rails.logger.info("Time to save medal stats: #{1000 * bm.real}ms")
          binding.pry

          [entries_cache, medal_stats_cache]
        end

        BroadcastLeaderboardChangesetService.call(
          entries: entries_cache.values,
          medal_statistics: medal_stats_cache.values,
        )
      end
    ensure
      Rails.logger.level = old_log_level
      Rails.logger.info("Rails log level reset!")
    end
  end
end
