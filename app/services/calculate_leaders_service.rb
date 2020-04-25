class CalculateLeadersService
  include FlexibleService

  def call(family_slug:, count:, timeframe:)
    family = Family.friendly.find(family_slug)

    return success(
      :found,
      OpenStruct.new(
        leaders: Achievement.leaders_for(family: family, since: Time.now - 1.month),
        family: family
      )
    )
  end
end
