class FindRivalryService
  include FlexibleService

  def initialize(leaderboard_calculator: CalculateLeadersService)
    @leaderboard_calculator = leaderboard_calculator
  end

  def call(user:, family_slug:)
    result = leaderboard_calculator.call(
      family_slug: family_slug,
      count: 10000,
      timeframe: :daily
    )

    result.on(:found) do |leaderboard|
      success(:found, Rivalry.new(user: user, leaderboard: leaderboard))
    end
  end

  private

  attr_reader :leaderboard_calculator
end
