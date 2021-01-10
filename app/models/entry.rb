class Entry < ApplicationRecord
  belongs_to :reified_leaderboard
  belongs_to :user

  has_many :medal_statistics

  def adjust_score(points)
    self.score += points
  end
end
