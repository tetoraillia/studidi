FactoryBot.define do
  factory :topic do
    title { Faker::Lorem.sentence }
    course { association(:course) }
    position { 1 }
  end
end
