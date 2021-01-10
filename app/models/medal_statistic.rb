class MedalStatistic < ApplicationRecord
  belongs_to :entry, touch: true
  belongs_to :medal

  scope :top_medals, -> (updated_since:, reified_leaderboard_id:, count: 5) do
    self
      .select("*")
      .from(<<-SQL
          (
            SELECT
              medal_statistics.*,
              RANK() OVER (PARTITION BY medal_statistics.reified_leaderboard_id, medal_statistics.user_id
                     ORDER BY medal_statistics.score DESC) AS medal_rank
            FROM
              medal_statistics
            WHERE score > 0
          ) as medal_statistics
        SQL
      )
      .where("medal_rank <= ?", count)
      .where("updated_at > ?", updated_since)
      .where("reified_leaderboard_id = ?", reified_leaderboard_id)
  end

  def add_medal(medal)
    self.count += 1
    self.score += medal.score
  end

  # takes score b/c assumes score can change
  def remove_medal(score)
    self.count -= 1
    self.score -= score
  end
end
