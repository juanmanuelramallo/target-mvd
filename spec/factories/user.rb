FactoryBot.define do
  sequence :email do |n|
    "user-#{n}@example.com"
  end

  factory :user do
    email
    uid { email }
    password "P@55word"
    password_confirmation "P@55word"
  end
end
