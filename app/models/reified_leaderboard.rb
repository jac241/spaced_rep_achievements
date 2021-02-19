class ReifiedLeaderboard < ApplicationRecord
  belongs_to :family
  has_many :entries, dependent: :destroy
  has_many :medal_statistics, through: :entries

  enum timeframe: {
    daily: 0,
    weekly: 1,
    monthly: 2,
  }

  def expiration_date
    case self.timeframe
    when "daily"
      1.day.ago
    when "weekly"
      1.week.ago
    when "monthly"
      1.month.ago
    end
  end

  def entry_for_user!(user)
    entries.find_or_create_by(user: user)
  end

  def channel
    "realtime:#{family.slug}:#{timeframe}"
  end

  def serializer(data_since: Time.at(0), meta: {})
    ReifiedLeaderboardSerializer.new(
      self,
      {
        include: [
          :entries,
          "entries.user",
          "entries.user.groups",
          "entries.medal_statistics",
          :medal_statistics,
          "medal_statistics.medal",
          "medal_statistics.entry",
          "entries.medal_statistics.medals",
        ],
        params: {
          data_since: data_since
        },
        meta: meta
      }
    )
  end
end
