class AddIndexToMedalStats < ActiveRecord::Migration[6.0]
  def change
    add_index :medal_statistics, :score
  end
end
