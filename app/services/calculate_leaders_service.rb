class CalculateLeadersService
  include FlexibleService

  def call(family_slug:, count:, timeframe:)
    family = Family.friendly.find(family_slug)

    return success(
      :found,
      Leaderboard.calculate(family: family, timeframe: timeframe)
    )
  end
end
