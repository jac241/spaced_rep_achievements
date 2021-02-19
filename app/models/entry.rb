class Entry < ApplicationRecord
  belongs_to :reified_leaderboard
  belongs_to :user

  has_many :medal_statistics
  has_many :top_medals, -> { top_medals }, class_name: "MedalStatistic"

  attribute :instance_score_delta, :integer, default: 0

  def adjust_score!(points)
    increment!(:score, points)
  end

  def persist_score_delta!
    increment!(:score, instance_score_delta)
    self.instance_score_delta = 0
  end
end
