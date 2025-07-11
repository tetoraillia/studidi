FactoryBot.define do
  factory :course do
    title { "Valid Course Title" }
    description { Faker::Lorem.sentence }
    public { true }
    association :instructor, factory: :user, strategy: :create, role: :teacher
  end
end
