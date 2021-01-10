class MakeMedalStatisticsBelongToEntry < ActiveRecord::Migration[6.0]
  def change
    add_reference :medal_statistics, :entry, index: true, type: :uuid
  end
end
