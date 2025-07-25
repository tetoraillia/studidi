FactoryBot.define do
  factory :response do
    association :user
    association :lesson
    content { "This is a test response content." }
  end
end
