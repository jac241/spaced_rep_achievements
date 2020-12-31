class Entry < ApplicationRecord
  belongs_to :reified_leaderboard, touch: true
  belongs_to :user

  def adjust_score(points)
    self.score += points
  end
end
