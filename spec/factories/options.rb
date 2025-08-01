FactoryBot.define do
  factory :option do
    title { Faker::Lorem.sentence(word_count: 5) }
    is_correct { false }
    question { association(:question) }
  end
end
