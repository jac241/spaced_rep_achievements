FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "jac241#{n}@example.com" }
    sequence(:username) { |n| "jac241-#{n}" }
    password { 'mypassword' }
    confirmed_at { Time.now }
  end
end
