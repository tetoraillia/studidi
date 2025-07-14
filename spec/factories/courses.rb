FactoryBot.define do
  factory :course do
    title { Faker::Book.title }
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
