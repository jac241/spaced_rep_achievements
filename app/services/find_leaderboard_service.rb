class FindLeaderboardService
  include FlexibleService
  LeaderboardDetails = Struct.new(:family_slug, :timeframe, keyword_init: true)

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
        maybe_achievement: user.achievements.in_order_earned.last
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
