class HomeController < ApplicationController
  def index
    @leaderboard_entries_count = 10

    result = CalculateLeadersService.call(
      family_slug: "halo-3",
      count: @leaderboard_entries_count,
      timeframe: :daily
    )

    result.on(:found) do |leaderboard|
      @leaderboard = LeaderboardDecorator.new(leaderboard)
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
