class Leaderboard
  attr_reader :leaders, :family, :timeframe

  def self.timeframes
    [:daily, :monthly, :weekly]
  end

  def initialize(leaders:, family:, timeframe:)
    @leaders = leaders
    @family = family
    @timeframe = timeframe
  end
end
