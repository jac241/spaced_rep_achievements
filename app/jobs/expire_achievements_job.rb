class ExpireAchievementsJob < ApplicationJob
  include ActiveSupport::Benchmarkable

  queue_as :realtime_leaderboard

  def perform
    ReifiedLeaderboard.find_each do |leaderboard|
      Rails.logger.info("Expiring for leaderboard: #{leaderboard.family.name} #{leaderboard.timeframe}")
      expirations =
        Expiration
        .expired_for_leaderboard(leaderboard).limit(10_000)

      Rails.logger.info('Load affected entries')
      affected_entries = Entry
                         .includes(:user)
                         .where(
                           reified_leaderboard: leaderboard,
                           user_id: Achievement.where(id: expirations.pluck(:achievement_id)).pluck(:user_id).uniq
                         )

      entries_cache =
        affected_entries
        .group_by { |e| [e.reified_leaderboard_id, e.user_id] }
        .transform_values { |v| v.first }

      Rails.logger.info('Load medal statistics')
      medal_stats_cache =
        MedalStatistic
        .includes(medal: :family, entry: [:user, :reified_leaderboard])
        .where(entry: affected_entries.pluck(:id))
        .group_by { |ms| [ms.entry_id, ms.medal_id] }
        .transform_values { |v| v.first }

      Rails.logger.info('Do expiration')
      benchmark 'Time to expire records' do
        expirations.each do |exp|
          exp.expire(entries_cache, medal_stats_cache)
        end
      end

      entries_cache, medal_stats_cache = ApplicationRecord.transaction do
        benchmark 'Time to delete_all expirations' do
          expired_count = Expiration.where(id: expirations.find_each.map(&:id)).delete_all
          Rails.logger.info("Number of Expirations: #{expired_count}")
        end

        Rails.logger.info("Number of entries affected: #{entries_cache.size}")
        Rails.logger.info("Number of medal stats affected: #{medal_stats_cache.size}")

        benchmark 'Time to save entries' do
          entries_cache.values.each { |e| e.persist_score_delta! }
        end

        benchmark 'Time to save medal stats' do
          medal_stats_cache.values.each do |ms|
            ms.persist_count_and_score_delta!
          end
        end

        [entries_cache, medal_stats_cache]
      end

      BroadcastLeaderboardChangesetService.call(
        entries: entries_cache.values,
        medal_statistics: medal_stats_cache.values
      )
    end
  end
end
