FactoryBot.define do
  factory :achievement do
    sequence(:client_db_id) { |n| n.to_i }
    client_medal_id { medal.client_medal_id }
    sequence(:client_deck_id) { |n| n.to_i }
    client_earned_at { Time.now }
    client_uuid { SecureRandom.uuid }
    client_db_uuid { SecureRandom.uuid }

    association :medal
    association :user
  end
end
