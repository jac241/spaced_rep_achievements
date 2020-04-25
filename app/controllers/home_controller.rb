class HomeController < ApplicationController
  def index
    result = CalculateLeadersService.call(
      family_name: "Halo 3",
      count: 10,
      timeframe: :day
    )

    result.on(:found) do |result|
      @leaderboard = LeaderboardDecorator.new(
        result.leaders, context: {
          family: result.family
        }
      )
    end
  end

  def terms
  end

  def privacy
  end

  private

  def game
    Family.find_by_name("Halo 3")
  end

end
