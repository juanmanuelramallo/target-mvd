# frozen_string_literal: true

FactoryBot.define do
  factory :conversation do
    association :initiator, factory: :user_with_targets, targets_count: 1
    target do
      create :target, topic: initiator.targets.first.topic,
                      lat: initiator.targets.first.lat, lng: initiator.targets.first.lng
    end
    unread { false }

    factory :conversation_with_messages do
      transient do
        messages_count { 5 }
      end

      after(:create) do |conversation, evaluator|
        evaluator.messages_count.times do
          create :message, conversation: conversation,
                           user: [conversation.initiator, conversation.target.user].sample
        end
      end
    end
  end
end
