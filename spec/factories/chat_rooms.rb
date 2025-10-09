FactoryBot.define do
  factory :chat_room do
    name { "General Chat" }
    description { "A place for general discussion" }

    trait :without_name do
      name { nil }
    end

    trait :duplicate_name do
      name { "Duplicate Room" }
    end

    trait :without_description do
      description { nil }
    end
  end
end