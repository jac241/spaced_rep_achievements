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

    ApplicationRecord.transaction do
      achievement.save!
      upsert_leaderboard_entries!(user, achievement.medal.family, achievement.medal.score)
    end

    success(:created, achievement)
  end

  def upsert_leaderboard_entries!(user, family, score)
    family.reified_leaderboards.find_each do |leaderboard|
      entry = leaderboard.entry_for_user(user)
      entry.adjust_score(score)
      entry.save!
    end
  end
end
