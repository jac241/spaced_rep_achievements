class Leaderboard
  MAX_COUNT = 1000

  attr_reader :leaders, :family, :timeframe, :top_medals

  def self.timeframes
    [:daily, :weekly, :monthly]
  end

  def self.calculate(family:, timeframe:, force_cache: false)
    Rails.cache.fetch(
      instance_cache_key(family, timeframe),
      force: force_cache
    ) do
      ApplicationRecord.transaction do
        Rails.logger.info("Calculating leaders...")
        since_datetime = starting_date(timeframe)
        new(
          leaders: Achievement.leaders_for(
            family: family,
            since: since_datetime,
          ).to_a,
          family: family,
          timeframe: timeframe,
          top_medals: Achievement.top_medals_for(
            family: family,
            since: since_datetime,
          ).to_a
        )
      end
    end
  end

  def initialize(leaders:, family:, timeframe:, top_medals:)
    @leaders = leaders
    @family = family
    @timeframe = timeframe
    @top_medals = top_medals
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
      top_medals: top_medals
    )
  end

  def entries
    @entries ||= leaders.map do |entry_for_user|
      Entry.new(
        entry_for_user: entry_for_user,
        top_medals_for_user: top_medals_by_user_id[entry_for_user.user_id],
      )
    end.tap do |entries|
      Rails.logger.info("#{entries.size} leaderboard entries for #{family.slug}:#{timeframe.to_s}")
    end
  end

  class Entry
    include ActiveModel::Model
    attr_accessor :entry_for_user, :top_medals_for_user

    delegate :family_rank, :user, :total_score, to: :entry_for_user
    delegate :achievements_count, :medal, to: :entry_for_user
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

  def top_medals_by_user_id
    top_medals.group_by(&:user_id)
  end
end
