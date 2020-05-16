class IndexAchievementsOnClientEarnedAt < ActiveRecord::Migration[6.0]
  def change
    add_index :achievements, :client_earned_at
  end
end
