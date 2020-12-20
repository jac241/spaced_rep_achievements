FactoryBot.define do
  factory :medal_statistic do
    association :user
    association :reified_leaderboard
    association :medal

    score { 0 }
    count { 0 }
  end
end
