class CreateReifiedLeaderboardsAndLeaderboardEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :reified_leaderboards, id: :uuid do |t|
      t.references :family, foreign_key: true, type: :uuid
      t.integer :timeframe

      t.timestamps
    end
    add_index :reified_leaderboards, [:family_id, :timeframe], unique: true

    create_table :entries, id: :uuid do |t|
      t.references :user, foreign_key: true
      t.references :reified_leaderboard, foreign_key: true, type: :uuid
      t.integer :score, null: false, default: 0

      t.timestamps
    end
    add_index :entries, :score
    add_index :entries, [:user_id, :reified_leaderboard_id], unique: true
  end
end
