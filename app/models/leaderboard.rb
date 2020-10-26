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
      ApplicationRecord.transaction(isolation: :repeatable_read) do
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
          ).to_a,
        )
      end
    end
  end

  def initialize(leaders:, family:, timeframe:, top_medals:, online_user_ids: Set.new) # Remove online_user_ids once cache cleared
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
      make_entry(entry_for_user)
    end.tap do |entries|
      Rails.logger.info("#{entries.size} leaderboard entries for #{family.slug}:#{timeframe.to_s}")
    end
  end

  def online_user_ids
    @online_user_ids ||= User.online_ids
  end

  def make_entry(entry_for_user)
    Entry.new(
      entry_for_user: entry_for_user,
      top_medals_for_user: top_medals_by_user_id[entry_for_user.user_id],
      user_online: online_user_ids.include?(entry_for_user.user.id),
      user_groups: groups_by_user_id.fetch(entry_for_user.user_id, []),
    )
  end

  def groups_by_user_id
    @groups_by_user_id ||= Membership
      .select(:member_id, :group_id)
      .includes(:group)
      .where(member_id: leaders.map(&:user_id))
      .group_by { |m| m.member_id }
      .transform_values { |m| m.map(&:group) }
  end

  class Entry
    include ActiveModel::Model
    attr_accessor :entry_for_user, :top_medals_for_user, :user_online, :user_groups

    delegate :family_rank, :user, :total_score, to: :entry_for_user
    delegate :achievements_count, :medal, to: :entry_for_user

    def user_groups_where_tag_present
      user_groups.select { |g| g.tag.present? }
    end

    def user_online?
      user_online
    end
  end

  class Details
    DEFAULT_FAMILY_SLUG = 'halo-3'
    DEFAULT_TIMEFRAME = :daily

    attr_reader :family, :timeframe

    def self.from(maybe_achievement:)
      if maybe_achievement.present?
        new(
          family: maybe_achievement.family,
          timeframe: achievments_timeframe(maybe_achievement),
        )
      else
        new(
          family: Family.friendly.find(DEFAULT_FAMILY_SLUG),
          timeframe: DEFAULT_TIMEFRAME,
        )
      end
    end

    def self.achievments_timeframe(achievement)
      earned_at = achievement.client_earned_at
      if earned_at > 1.day.ago
        :daily
      elsif earned_at > 1.week.ago
        :weekly
      elsif earned_at > 1.month.ago
        :monthly
      else
        :daily
      end
    end

    def initialize(family:, timeframe:)
      @family = family
      @timeframe = timeframe
    end
  end

  def top_medals_by_user_id
    top_medals.group_by(&:user_id)
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
