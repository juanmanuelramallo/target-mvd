# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    user
    conversation
    text { Faker::Quote.matz }
  end
end
