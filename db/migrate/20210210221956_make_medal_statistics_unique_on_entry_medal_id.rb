class MakeMedalStatisticsUniqueOnEntryMedalId < ActiveRecord::Migration[6.0]
  def change
    remove_index :medal_statistics, name: "idx_med_stats_on_user_lb_medal"
    add_index :medal_statistics, [:entry_id, :medal_id], unique: true
  end
end
