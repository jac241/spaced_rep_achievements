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

  attribute :instance_count_delta, :integer, default: 0
  attribute :instance_score_delta, :integer, default: 0

  def add_medal!(medal)
    increment!(:count, touch: true)
    increment!(:score, medal.score, touch: true)
  end

  # takes score b/c assumes score can change
  def tally_medal_removal(score)
    self.instance_count_delta -= 1
    self.instance_score_delta -= score
  end

  def persist_count_and_score_delta!
    increment!(:count, instance_count_delta, touch: true)
    increment!(:score, instance_score_delta, touch: true)
  end
end
