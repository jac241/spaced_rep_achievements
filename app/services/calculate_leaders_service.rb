class CalculateLeadersService
  include FlexibleService

  def call(timeframe:, count: Leaderboard::MAX_COUNT, family: nil, family_slug: nil)
    if not (family || family_slug)
      raise "Call requires family or family_slug to calculate leaderboard"
    end

    unless family.present?
      family = Family.friendly.find(family_slug)
    end

    return success(
      :found,
      Leaderboard.calculate(family: family, timeframe: timeframe).first(count)
    )
  end
end
