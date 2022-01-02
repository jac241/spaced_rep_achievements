FactoryBot.define do
  factory :medal_tracker_challenge, class: 'ChallengeTypes::MedalTracker' do
    sequence(:title) { |n| "mt challenge #{n}" }
    sequence(:xp) { |n| n.to_i }

    association :battle_pass
  end
end
