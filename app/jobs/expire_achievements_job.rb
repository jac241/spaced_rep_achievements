class ExpireAchievementsJob < ApplicationJob
  def perform
    affected_records = ApplicationRecord.transaction do
      ReifiedLeaderboard.find_each.flat_map do |leaderboard|
        Expiration.expired_for_leaderboard(leaderboard).find_each.map(&:expire!)
      end
    end

    BroadcastLeaderboardChangesetService.call(affected_records: affected_records)
  end
end
