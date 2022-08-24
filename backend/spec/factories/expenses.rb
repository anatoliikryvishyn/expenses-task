FactoryBot.define do
  factory :expense do
    association :account

    amount { Faker::Number.between(from: 1, to: 1000) }
    date { Faker::Date.backward(days: 1) }
    description { Faker::Lorem.characters(number: 10) }
  end
end
