FactoryBot.define do
  factory :target do
    area_length { rand 1000 }
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }
    title { Faker::Name.name }
    topic
    user
  end
end