class DeleteOldAchievementsJob < ApplicationJob
  queue_as :sync

  def perform
    Achievement.where("client_earned_at < ?", 2.months.ago).delete_all
  end
end
