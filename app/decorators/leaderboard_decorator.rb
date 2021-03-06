class LeaderboardDecorator < ApplicationDecorator
  delegate_all
  decorates_association :entries, with: EntryDecorator

  def title
    "Top #{object.family.name} reviewers #{timeframe_for_title}"
  end

  def count_limited_title(count)
    "Top #{[count, leaders.size].min} #{object.family.name} reviewers #{timeframe_for_title}"
  end

  private

  def timeframe_for_title
    case object.timeframe.to_s
    when 'daily'
      'today'
    when 'weekly'
      'this week'
    when 'monthly'
      'this month'
    end
  end
end
