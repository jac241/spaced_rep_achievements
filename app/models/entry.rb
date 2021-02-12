class Entry < ApplicationRecord
  belongs_to :reified_leaderboard
  belongs_to :user

  has_many :medal_statistics
  has_many :top_medals, -> { top_medals }, class_name: "MedalStatistic"

  def adjust_score(points)
    self.score += points
  end
end
