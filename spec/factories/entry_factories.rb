FactoryBot.define do
  factory :entry do
    association :user
    association :reified_leaderboard

    score { 0 }
  end
end
