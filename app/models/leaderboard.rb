class Leaderboard
  MAX_COUNT = 1000

  attr_accessor :leaders, :family, :timeframe

  def self.timeframes
    [:daily, :weekly, :monthly]
  end

  def self.calculate(family:, timeframe:, force_cache: false)
    Rails.cache.fetch(
      instance_cache_key(family, timeframe),
      force: force_cache
    ) do
      Rails.logger.info("Calculating leaders...")
      new(
        leaders: Achievement.leaders_for(
          family: family,
          since: starting_date(timeframe),
        ).to_a,
        family: family,
        timeframe: timeframe
      )
    end
  end

  def initialize(leaders:, family:, timeframe:)
    @leaders = leaders
    @family = family
    @timeframe = timeframe
  end

  def channel
    "#{family.slug}:#{timeframe}"
  end

  def cache_key
    "#{family.slug}/#{timeframe}"
  end

  def first(count)
    self.class.new(
      leaders: leaders.to_a.first(count),
      family: family,
      timeframe: timeframe,
    )
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

  def self.instance_cache_key(family, timeframe)
    "#{family.slug}/#{timeframe}/instance"
  end
end
