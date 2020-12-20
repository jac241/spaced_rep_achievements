class ReifiedLeaderboard < ApplicationRecord
  belongs_to :family
  has_many :entries, dependent: :destroy

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
end
