FactoryBot.define do
  factory :medal do
    name { "Double Kill" }
    client_medal_id { "Double Kill" }
    rank { 2 }
    score { 2 }

    association :family
  end
end
