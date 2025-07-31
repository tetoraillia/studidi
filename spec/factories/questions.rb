FactoryBot.define do
  factory :question do
    title { Faker::Lorem.sentence(word_count: 5) }
    lesson { association(:lesson) }
  end
end
