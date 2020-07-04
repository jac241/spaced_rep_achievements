class CalculateLeadersService
  include FlexibleService

  def call(family_slug:, timeframe:, count: Leaderboard::MAX_COUNT)
    family = Family.friendly.find(family_slug)

    return success(
      :found,
      Leaderboard.calculate(family: family, timeframe: timeframe).first(count)
    )
  end
end
