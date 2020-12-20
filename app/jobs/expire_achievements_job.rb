class ExpireAchievementsJob < ApplicationJob
  def perform
    ApplicationRecord.transaction do
      ReifiedLeaderboard.find_each do |leaderboard|
        Expiration.expired_for_leaderboard(leaderboard).each(&:expire!)
      end
    end
  end
end
