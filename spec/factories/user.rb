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
  end
end
