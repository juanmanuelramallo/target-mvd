# frozen_string_literal: true

FactoryBot.define do
  factory :target do
    area_length { rand(1..1000) }
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }
    title { Faker::Name.name }
    topic
    user
  end
end
