FactoryBot.define do
  factory :medal_statistic do
    association :entry
    association :medal

    score { 0 }
    count { 0 }
  end
end
