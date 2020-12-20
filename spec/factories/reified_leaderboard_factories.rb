FactoryBot.define do
  factory :reified_leaderboard do
    association :family
    timeframe { :daily }
  end
end
