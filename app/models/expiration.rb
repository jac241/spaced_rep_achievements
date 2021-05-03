class Expiration < ApplicationRecord
  belongs_to :reified_leaderboard
  belongs_to :achievement

  scope :expired_for_leaderboard, -> (leaderboard) do
    joins(:achievement)
      .where(reified_leaderboard: leaderboard)
      .where("achievements.client_earned_at < ?", leaderboard.expiration_date)
      .includes(:reified_leaderboard)
  end

  def expire(entries_cache, medal_stats_cache)
    entry = entries_cache[[reified_leaderboard_id, achievement.user_id]]
    entry.instance_score_delta -= self.points

    stats = medal_stats_cache[[entry.id, achievement.medal_id]]
    stats.tally_medal_removal(achievement.medal.score)

    self
  end
end
