class RemoveUserFromMedalStatistics < ActiveRecord::Migration[6.0]
  def change
    remove_index :medal_statistics, :user_id
    remove_column :medal_statistics, :user_id
  end
end
