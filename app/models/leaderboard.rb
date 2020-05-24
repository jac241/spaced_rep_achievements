class Leaderboard
  attr_reader :leaders, :family, :timeframe

  def self.timeframes
    [:daily, :weekly, :monthly]
  end

  def self.calculate(family:, timeframe:)
    new(
      leaders: Achievement.leaders_for(
        family: family,
        since: starting_date(timeframe),
      ),
      family: family,
      timeframe: timeframe
    )
  end

  def initialize(leaders:, family:, timeframe:)
    @leaders = leaders
    @family = family
    @timeframe = timeframe
  end

  def channel
    "#{family.slug}:#{timeframe}"
  end

  private

  def self.starting_date(timeframe)
    case timeframe.to_s
    when 'monthly'
      Time.now - 1.month
    when 'weekly'
      Time.now - 1.week
    when 'daily'
      Time.now - 1.day
    end
  end
end
