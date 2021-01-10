class ReferMedalStatisticsToEntries < ActiveRecord::Migration[6.0]
  def up
    Entry.includes(:reified_leaderboard, :user).find_each do |entry|
      MedalStatistic.where(
        reified_leaderboard: entry.reified_leaderboard,
        user: entry.user,
      ).update_all(entry_id: entry.id)
    end
  end

  def down
    MedalStatistic.update_all(entry_id: nil)
  end
end
