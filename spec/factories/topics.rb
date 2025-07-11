FactoryBot.define do
  factory :topic do
    title { Faker::Lorem.words(number: 2).join(' ').capitalize }
    course { association(:course) }
    position { 1 }  
  end
end
