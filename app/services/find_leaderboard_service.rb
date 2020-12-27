class FindLeaderboardService
  include FlexibleService

  def initialize(calculate_leaderboard: CalculateLeadersService)
    @calculate_leaderboard = calculate_leaderboard
  end

  def call(user:, maybe_family_slug:, maybe_timeframe:)
    if leaderboard_info_provided?(maybe_family_slug, maybe_timeframe)
      calculate_leaderboard.call(
        family_slug: maybe_family_slug,
        timeframe: maybe_timeframe,
      )
    else
      leaderboard_details = Leaderboard::Details.from(
        maybe_achievement: user.latest_achievement
      )

      calculate_leaderboard.call(
        family: leaderboard_details.family,
        timeframe: leaderboard_details.timeframe,
      )
    end
  end

  private

  def leaderboard_info_provided?(maybe_family_slug, maybe_timeframe)
    maybe_family_slug && maybe_timeframe
  end

  attr_reader :calculate_leaderboard
end
