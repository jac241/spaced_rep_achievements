class CreateAchievementService
  include FlexibleService

  def call(create_params:, user:)
    create_achievement!(create_params, user)
  rescue ActiveRecord::RecordInvalid => e
    failure(:invalid_params, e.record.errors)
  end

  private

  def create_achievement!(create_params, user)
    achievement = user.achievements.new(create_params)
    achievement.medal = Medal.find_by_client_medal_id(create_params[:client_medal_id])

    stats = ApplicationRecord.transaction do
      achievement.save!

      result = AfterAchievementCreatedService.call(
        achievement: achievement,
        user: user
      )

      result.body.medal_statistics
    end

    BroadcastLeaderboardUpdatesJob.perform_later(medal_statistics: stats)

    success(:created, achievement)
  end
end
