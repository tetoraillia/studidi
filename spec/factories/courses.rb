FactoryBot.define do
  factory :course do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    instructor { association(:user, :teacher) }

    trait :private do
      public { false }
    end

    trait :public do
      public { true }
    end
  end
end
