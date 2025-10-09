FactoryBot.define do
  factory :user do
    full_name { "John Doe" }
    email { "user@example.com" }
    password { "password123" }
    password_confirmation { "password123" }

    trait :with_different_email do
      sequence(:email) { |n| "user#{n}@example.com" }
    end

    trait :without_full_name do
      full_name { nil }
    end

    trait :invalid_email do
      email { "invalid-email" }
    end

    trait :short_password do
      password { "123" }
      password_confirmation { "123" }
    end
  end
end