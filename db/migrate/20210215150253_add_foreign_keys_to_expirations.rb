class AddForeignKeysToExpirations < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :expirations, :achievements
    add_foreign_key :expirations, :reified_leaderboards
  end
end
