FactoryBot.define do
  factory :invitation do
    association :course
    association :invited_by, factory: :user
    email { "invitee@example.com" }
    status { "pending" }
    token { SecureRandom.hex(20) }
  end
end
