FactoryBot.define do
  factory :response do
    association :user
    association :responseable, factory: :lesson
    content { "This is a test response content." }
  end
end
