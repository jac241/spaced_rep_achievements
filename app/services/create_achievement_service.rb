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

    entries, stats = ApplicationRecord.transaction do
      achievement.save!

      entries = upsert_leaderboard_entries!(user, achievement.medal.family, achievement.medal.score)
      stats = upsert_medal_statistics!(user, achievement.medal.family, achievement.medal)
      create_achievement_expirations!(achievement)

      [ entries, stats ]
    end

    BroadcastLeaderboardUpdatesJob.perform_later(entries: entries, medal_statistics: stats)

    success(:created, achievement)
  end

  def upsert_leaderboard_entries!(user, family, score)
    family.reified_leaderboards.find_each.map do |leaderboard|
      leaderboard.entry_for_user(user).tap do |entry|
        entry.adjust_score(score)
        entry.save!
      end
    end
  end

  def upsert_medal_statistics!(user, family, medal)
    family.reified_leaderboards.find_each.map do |leaderboard|
      MedalStatistic.find_or_initialize_by(
        user: user,
        reified_leaderboard: leaderboard,
        medal: medal
      ).tap do |stats|
        stats.add_medal(medal)
        stats.save!
      end
    end
  end

  def create_achievement_expirations!(achievement)
    leaderboard_ids = achievement.medal.family.reified_leaderboards.pluck(:id)
    points = achievement.medal.score

    achievement.expirations.import! (
      leaderboard_ids.map do |rlbid|
        {
          reified_leaderboard_id: rlbid,
          points: points
        }
      end
    )
  end
end
