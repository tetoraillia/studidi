FactoryBot.define do
  factory :lesson do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }
    topic { association(:topic) }
    position { 1 }

    trait :with_video do
      content_type { "video" }
      video_url { "https://www.youtube.com/watch?v=dQw4w9WgXcQ" }
    end

    trait :with_text do
      content_type { "text" }
      content { Faker::Lorem.sentence }
    end

    trait :with_test do
      content_type { "test" }
      content { Faker::Lorem.sentence }
    end
  end
end
