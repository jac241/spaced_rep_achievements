class CalculateLeadersService
  include FlexibleService

  def call(family_name:, count:, timeframe:)
    family = Family.find_by_name(family_name)

    return success(
      :found,
      OpenStruct.new(
        leaders: Achievement.leaders_for(family: family, since: Time.now - 1.month),
        family: family
      )
    )
  end
end
