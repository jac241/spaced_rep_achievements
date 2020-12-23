class IndexEntriesMedalStatisticsOnUpdatedAt < ActiveRecord::Migration[6.0]
  def change
    add_index :entries, :updated_at
    add_index :medal_statistics, :updated_at
  end
end
