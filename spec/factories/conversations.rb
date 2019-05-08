# frozen_string_literal: true

FactoryBot.define do
  factory :conversation do
    association :initiator, factory: :user_with_targets, targets_count: 1
    target do
      create :target, topic: initiator.targets.first.topic,
                      lat: initiator.targets.first.lat, lng: initiator.targets.first.lng
    end
  end
end
