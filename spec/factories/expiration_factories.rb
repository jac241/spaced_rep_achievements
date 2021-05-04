FactoryBot.define do
  factory :expiration do
    association :achievement
    association :reified_leaderboard

    points { achievement.medal.score }
    achievement_client_earned_at { achievement.client_earned_at }
  end
end

