class Expiration < ApplicationRecord
  belongs_to :reified_leaderboard
  belongs_to :achievement

  scope :expired_for_leaderboard, -> (leaderboard) do
    where(reified_leaderboard: leaderboard)
      .where("created_at < ?", leaderboard.expiration_date)
      .includes(:reified_leaderboard, achievement: [ :medal ])
  end

  AffectedRecord = Struct.new(:entry, :medal_statistic)
  def expire!
    entry = reified_leaderboard.entries.find_by(user_id: achievement.user_id) # ids to prevent loading record
    entry.adjust_score(-self.points)
    entry.save!

    stats = reified_leaderboard.medal_statistics.find_by(
      user_id: achievement.user_id,
      medal_id: achievement.medal_id
    )
    stats.remove_medal(achievement.medal.score)
    stats.save!

    destroy!

    AffectedRecord.new(entry, stats)
  end
end
