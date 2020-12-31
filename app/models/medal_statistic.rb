class MedalStatistic < ApplicationRecord
  belongs_to :user
  belongs_to :reified_leaderboard, touch: true
  belongs_to :medal

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
