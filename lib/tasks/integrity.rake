namespace :integrity do
  task :ensure => :environment do
    ReifiedLeaderboard.all.each do |rlb|
      puts "Realtime leaderboard: #{rlb}"

      ApplicationRecord.transaction(isolation: :repeatable_read) do
        exps = Expiration .joins(achievement: :medal) .where("expirations.reified_leaderboard_id = ?", rlb.id) .select("achievements.user_id as uid, medals.id as mid, count(*) as medals_count") .group("uid, mid").group_by { |rec| [rec.uid, rec.mid] }.transform_values(&:first)

        mss = MedalStatistic
          .includes(:entry)
          .joins(entry: :reified_leaderboard)
          .where(entries: {reified_leaderboard: rlb})
          .group_by { |ms| [ms.entry.user_id, ms.medal_id] }
          .transform_values(&:first)

        changed_medal_statistics = exps.map do |(uid, mid), grouped_expirations|
          medal_stats = mss.fetch([uid, mid])
          count_diff = grouped_expirations.medals_count - medal_stats.count
          if count_diff != 0
            medal_stats.count += count_diff
            medal_stats.score += count_diff * medal_stats.medal.score
            medal_stats.save!
            medal_stats
          end
        end.compact

        puts "#{changed_medal_statistics.size} medal statistics modified"
        affected_entries = changed_medal_statistics.map(&:entry).uniq

        affected_entries.each do |entry|
          entry.score = entry.medal_statistics.sum(:score)
          entry.save!
        end
        puts "#{changed_medal_statistics.size} entries modified"
      end
    end
  end
end
