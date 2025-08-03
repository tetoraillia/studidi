FactoryBot.define do
  factory :mark do
    association :user
    association :lesson
    association :response
    value { rand(0..100) }
    comment { "Test comment" }
  end
end
