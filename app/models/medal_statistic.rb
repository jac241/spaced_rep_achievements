class MedalStatistic < ApplicationRecord
  belongs_to :entry
  belongs_to :medal

  scope :top_medals, -> (reified_leaderboard_id: nil, updated_since: 1.month.ago, count: 5) do
    self
      .select("medal_statistics.*")
      .from(<<-SQL
          (
            SELECT
              medal_statistics.*,
              RANK() OVER (PARTITION BY medal_statistics.entry_id
                     ORDER BY medal_statistics.score DESC) AS medal_rank
            FROM
              medal_statistics
            WHERE medal_statistics.score > 0
          ) as medal_statistics
        SQL
      )
      .where("medal_statistics.medal_rank <= ?", count)
      .where("medal_statistics.updated_at > ?", updated_since)
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
