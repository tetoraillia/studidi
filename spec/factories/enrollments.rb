FactoryBot.define do
  factory :enrollment do
    association :user
    association :course
    enrolled_at { Time.current }
  end
end
