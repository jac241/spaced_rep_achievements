namespace :reset do
  task :daily => :environment do
    ReifiedLeaderboard.where(timeframe: :daily).each do |rlb|
      Entry.includes(:medal_statistics).where(reified_leaderboard: rlb).each do |entry|
        ActiveRecord::Base.transaction do
          entry.update!(score: 0)
          entry.medal_statistics.each do |ms|
            ms.update!(score: 0, count: 0)
          end
        end
        puts "Reset Entry: #{entry.id}"
      end

      rlb.expirations.destroy_all
    end
  end
end
