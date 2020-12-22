class ReifiedLeaderboard < ApplicationRecord
  belongs_to :family
  has_many :entries, dependent: :destroy
  has_many :medal_statistics, dependent: :destroy

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

  def entry_for_user(user)
    entries.find_or_initialize_by(user: user)
  end

  def channel
    "realtime:#{family.slug}:#{timeframe}"
  end

  def serializer
    rl = ReifiedLeaderboard
      .where(id: self.id)
      .includes(
        :family,
        entries: { user: [ :groups ] },
        medal_statistics: [:medal]
      ).first

    ReifiedLeaderboardSerializer.new(
      rl,
      {
        include: [
          :family,
          :entries,
          :medal_statistics,
          "entries.user",
          "entries.user.groups",
          "medal_statistics.medal",
        ]
      }
    )
  end
end
