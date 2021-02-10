class AfterAchievementCreatedService
  include FlexibleService

  def call(achievement:, user:)
    entries, stats = ApplicationRecord.transaction do
      entries = upsert_leaderboard_entries!(
        user,
        achievement.medal.family,
        achievement.medal.score
      )
      stats = upsert_medal_statistics!(
        entries,
        achievement.medal
      )
      create_achievement_expirations!(achievement)

      [ entries, stats ]
    end

    success(:created, OpenStruct.new(entries: entries, medal_statistics: stats))
  end

  private

  def upsert_leaderboard_entries!(user, family, score)
    family.reified_leaderboards.find_each.map do |leaderboard|
      leaderboard.entry_for_user(user).tap do |entry|
        entry.adjust_score(score)
        entry.save!
      end
    end
  end

  def upsert_medal_statistics!(entries, medal)
    entries.map do |entry|
      MedalStatistic.find_or_initialize_by(
        entry: entry,
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
