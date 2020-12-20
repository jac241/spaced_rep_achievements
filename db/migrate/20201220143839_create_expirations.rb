class CreateExpirations < ActiveRecord::Migration[6.0]
  def change
    create_table :expirations do |t|
      t.references :achievement, type: :uuid
      t.references :reified_leaderboard, type: :uuid

      t.integer :points, null: false
      t.timestamps
    end
  end
end
