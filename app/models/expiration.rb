class Expiration < ApplicationRecord
  belongs_to :reified_leaderboard
  belongs_to :achievement

  scope :expired_for_leaderboard, -> (leaderboard) do
    joins(:achievement)
      .where(reified_leaderboard: leaderboard)
      .where("achievements.client_earned_at < ?", leaderboard.expiration_date)
      .includes(:reified_leaderboard, achievement: [ :medal ])
  end

  def expire(entries_cache, medal_stats_cache)
    entry = entries_cache[[reified_leaderboard, achievement.user_id]]
    entry.adjust_score(-self.points)

    stats = medal_stats_cache[[entry, achievement.medal_id]]
    stats.remove_medal(achievement.medal.score)

    self
  end

  private

  def self.cache_for_entries
    Hash.new do |cache, (reified_leaderboard, user_id)|
      cache[[reified_leaderboard, user_id]] =
        reified_leaderboard.entries.find_by(user_id: user_id)
    end
  end

  def self.cache_for_medal_statistics
    Hash.new do |cache, (entry, medal_id)|
      cache[[entry, medal_id]] =
        entry.medal_statistics.find_by(medal_id: medal_id)
    end
  end
end
