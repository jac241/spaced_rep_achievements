class Expiration < ApplicationRecord
  belongs_to :reified_leaderboard
  belongs_to :achievement

  scope :expired_for_leaderboard, -> (leaderboard) do
      where(reified_leaderboard: leaderboard)
        .where("achievement_client_earned_at < ?", leaderboard.expiration_date)
        .includes(:reified_leaderboard)
  end

  def expire(entries_cache, medal_stats_cache)
    #entry = entries_cache[[reified_leaderboard_id, achievement.user_id]]
    entry = entries_cache.fetch([reified_leaderboard_id, achievement.user_id]) do
      Entry.find_by(
        reified_leaderboard_id: reified_leaderboard_id,
        user_id: achievement.user_id
      )
    end
    entry.instance_score_delta -= self.points

    stats = medal_stats_cache[[entry.id, achievement.medal_id]]
    stats.tally_medal_removal(achievement.medal.score)

    self
  end
end
