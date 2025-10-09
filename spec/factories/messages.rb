FactoryBot.define do
  factory :message do
    content { "Hello, this is a test message!" }
    association :user
    association :chat_room

    trait :without_content do
      content { nil }
    end

    trait :empty_content do
      content { "" }
    end

    trait :long_content do
      content { "This is a very long message that contains a lot of text to test various scenarios in our chat application." }
    end
  end
end