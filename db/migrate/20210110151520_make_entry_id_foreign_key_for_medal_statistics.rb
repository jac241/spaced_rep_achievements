class MakeEntryIdForeignKeyForMedalStatistics < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :medal_statistics, :entries
  end
end
