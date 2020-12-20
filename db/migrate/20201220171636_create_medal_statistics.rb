class CreateMedalStatistics < ActiveRecord::Migration[6.0]
  def change
    create_table :medal_statistics do |t|
      t.references :user, foreign_key: true
      t.references :reified_leaderboard, foreign_key: true, type: :uuid
      t.references :medal, foreign_key: true, type: :uuid

      t.integer :count, null: false, default: 0
      t.integer :score, null: false, default: 0

      t.timestamps
    end

    add_index :medal_statistics, [:user_id, :reified_leaderboard_id, :medal_id], unique: true, name: "idx_med_stats_on_user_lb_medal"
  end
end
