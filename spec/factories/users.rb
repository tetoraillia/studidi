FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password(min_length: 8) }
    password_confirmation { |u| u.password }
    encrypted_password { "some_hashed_password_for_tests" }

    trait :teacher do
      role { "teacher" }
    end

    trait :student do
      role { "student" }
    end
  end
end
