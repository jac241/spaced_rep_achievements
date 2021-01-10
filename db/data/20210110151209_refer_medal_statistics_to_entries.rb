class ReferMedalStatisticsToEntries < ActiveRecord::Migration[6.0]
  def up
    Entry.includes(:reified_leaderboard, :user).find_each do |entry|
      MedalStatistic.where(
        reified_leaderboard_id: entry.reified_leaderboard.id,
        user_id: entry.user_id,
      ).update_all(entry_id: entry.id)
    end
  end

  def down
    MedalStatistic.update_all(entry_id: nil)
  end
end
