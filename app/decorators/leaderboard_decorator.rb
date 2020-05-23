class LeaderboardDecorator < ApplicationDecorator
  delegate_all
  decorates_association :leaders, with: LeaderDecorator

  def title
    "Top #{10} for #{object.family.name}: past #{timeframe_for_title}"
  end

  def channel
    "#{family.slug}:#{timeframe}"
  end

  private

  def timeframe_for_title
    case object.timeframe
    when 'daily'
      'day'
    when 'weekly'
      'week'
    when 'monthly'
      'month'
    end
  end
end
