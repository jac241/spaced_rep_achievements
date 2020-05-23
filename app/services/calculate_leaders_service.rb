class CalculateLeadersService
  include FlexibleService

  def call(family_slug:, count:, timeframe:)
    family = Family.friendly.find(family_slug)

    return success(
      :found,
      Leaderboard.new(
        leaders: Achievement.leaders_for(
          family: family,
          since: starting_date(timeframe),
        ),
        family: family,
        timeframe: timeframe,
      )
    )
  end

  private

  def starting_date(timeframe)
    case timeframe
    when 'monthly'
      Time.now - 1.month
    when 'weekly'
      Time.now - 1.week
    when 'daily'
      Time.now - 1.day
    end
  end
end
