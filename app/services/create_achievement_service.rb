class CreateAchievementService
  include FlexibleService

  def call(create_params:, user:)
    achievement = user.achievements.new(create_params)
    achievement.medal = Medal.find_by_client_medal_id(create_params[:client_medal_id])

    if achievement.save
      success(:created, achievement)
    else
      failure(:invalid_params, achievement.errors)
    end
  end
end
