FactoryBot.define do
  factory :topic do
    name { Faker::Name.unique.name }
  end
end
