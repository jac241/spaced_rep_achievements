class Entry < ApplicationRecord
  belongs_to :reified_leaderboard
  belongs_to :user

  def adjust_score(points)
    self.score = self.score + points
  end
end
