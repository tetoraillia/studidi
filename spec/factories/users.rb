FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'password123' }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    role { :student }

    trait :student do
      role { :student }
    end

    trait :teacher do
      role { :teacher }
    end
  end
end
