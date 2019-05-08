# frozen_string_literal: true

FactoryBot.define do
  sequence :email do |n|
    "user-#{n}@example.com"
  end

  factory :user do
    confirmed_at { DateTime.now.in_time_zone }
    email
    password { 'P@55word' }
    password_confirmation { 'P@55word' }
    uid { email }

    factory :user_with_targets do
      transient do
        targets_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list :target, evaluator.targets_count, user: user
      end
    end
  end
end
