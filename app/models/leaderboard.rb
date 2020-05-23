class Leaderboard
  attr_reader :leaders, :family, :timeframe

  def self.timeframes
    [:daily, :weekly, :monthly]
  end

  def initialize(leaders:, family:, timeframe:)
    @leaders = leaders
    @family = family
    @timeframe = timeframe
  end
end
