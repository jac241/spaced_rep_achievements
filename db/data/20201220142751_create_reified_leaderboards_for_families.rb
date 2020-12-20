class CreateReifiedLeaderboardsForFamilies < ActiveRecord::Migration[6.0]
  def up
    Family.find_each do |family|
      ReifiedLeaderboard.timeframes.each do |timeframe, value|
        ReifiedLeaderboard.create!(family: family, timeframe: timeframe)
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
