FactoryBot.define do
  factory :account do
    name { Faker::Bank.name }
    number { Faker::Bank.iban }
    balance { 1000 }
  end
end
