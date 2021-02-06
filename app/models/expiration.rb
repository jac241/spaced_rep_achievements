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
end
