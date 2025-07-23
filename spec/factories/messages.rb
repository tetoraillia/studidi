FactoryBot.define do
  factory :message do
    content { Faker::Lorem.sentence }
    user { association(:user) }
  end
end
