class ChangeUniqueIndexOnAchievementsToIncludeClientEarnedAt < ActiveRecord::Migration[6.0]
  def change
    add_index :achievements, [:client_uuid, :client_db_id, :client_earned_at], unique: true, name: "index_achievements_on_uuid_db_id_and_earned_at"
    remove_index :achievements, name: "index_achievements_on_client_uuid_and_client_db_id"
  end
end
