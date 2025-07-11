FactoryBot.define do
  factory :topic do
    title { Faker::Lorem.words(number: 2).join(' ').capitalize }
    course { association(:course) }
    position { Faker::Number.between(from: 1, to: 10) }
  end
end
