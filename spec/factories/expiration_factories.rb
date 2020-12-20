FactoryBot.define do
  factory :expiration do
    association :achievement
    association :reified_leaderboard

    points { achievement.medal.score }
  end
end

