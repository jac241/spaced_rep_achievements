FactoryBot.define do
  factory :sync do
    client_uuid { SecureRandom.uuid }

    association :user
  end
end
