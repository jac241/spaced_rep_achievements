class Expiration < ApplicationRecord
  belongs_to :reified_leaderboard
  belongs_to :achievement

  scope :expired_for_leaderboard, -> (leaderboard) do
    where(reified_leaderboard: leaderboard)
      .where("created_at < ?", leaderboard.expiration_date)
  end

  def expire!
    entry = reified_leaderboard.entries.find_by(user: achievement.user)
    entry.adjust_score(-self.points)
    entry.save!

    stats = reified_leaderboard.medal_statistics.find_by(
      user: achievement.user,
      medal: achievement.medal
    )
    stats.remove_medal(achievement.medal.score)
    stats.save!

    destroy!
  end
end
