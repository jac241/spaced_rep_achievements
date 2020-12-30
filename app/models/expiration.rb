class Expiration < ApplicationRecord
  belongs_to :reified_leaderboard
  belongs_to :achievement

  scope :expired_for_leaderboard, -> (leaderboard) do
    where(reified_leaderboard: leaderboard)
      .where("created_at < ?", leaderboard.expiration_date)
      .includes(:reified_leaderboard, achievement: [ :medal ])
  end

  def expire(entries_cache, medal_stats_cache)
    entry = entries_cache[[reified_leaderboard, achievement.user_id]]
    entry.adjust_score(-self.points)

    stats = medal_stats_cache[[reified_leaderboard, achievement.user_id, achievement.medal_id]]
    stats.remove_medal(achievement.medal.score)

    self
  end

  private

  def self.cache_for_entries
    Hash.new do |cache, reified_leaderboard_user_id_pair|
      cache[reified_leaderboard_user_id_pair] =
        reified_leaderboard_user_id_pair.first.entries.find_by(
          user_id: reified_leaderboard_user_id_pair.second
        )
    end
  end

  def self.cache_for_medal_statistics
    Hash.new do |cache, rlb_user_id_medal_id_triple|
      cache[rlb_user_id_medal_id_triple] =
        rlb_user_id_medal_id_triple.first.medal_statistics.find_by(
          user_id: rlb_user_id_medal_id_triple.second,
          medal_id: rlb_user_id_medal_id_triple.third,
        )
    end
  end

end
