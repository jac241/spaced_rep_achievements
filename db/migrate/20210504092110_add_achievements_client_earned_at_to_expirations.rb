class AddAchievementsClientEarnedAtToExpirations < ActiveRecord::Migration[6.0]
  def up
    add_column :expirations, :achievement_client_earned_at, :datetime
    ActiveRecord::Base.connection.execute(
      <<-SQL
        UPDATE expirations e
        SET achievement_client_earned_at = a.client_earned_at
        FROM achievements a
        WHERE e.achievement_id = a.id;
      SQL
    )
    change_column :expirations, :achievement_client_earned_at, :datetime,
      null: false, index: true
  end
end
