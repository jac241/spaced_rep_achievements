class IndexExpirationsOnAchievementClientEarnedAt < ActiveRecord::Migration[6.0]
  def change
    add_index :expirations, :achievement_client_earned_at
  end
end
