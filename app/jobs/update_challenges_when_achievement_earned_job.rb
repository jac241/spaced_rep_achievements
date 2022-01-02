class UpdateChallengesWhenAchievementEarnedJob < ApplicationJob
  def perform(achievement)
    achievement.user.challenges.active.find_each do |challenge|
      challenge.update_if_applicable!({ achievement: achievement })
    end
  end
end
