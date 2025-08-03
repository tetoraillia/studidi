FactoryBot.define do
  factory :noticed_notification, class: 'Noticed::Notification' do
    association :recipient, factory: :user
    association :event, factory: :noticed_event
    type { 'Noticed::Notification' }
    read_at { nil }
    seen_at { nil }
  end

  factory :read_noticed_notification, parent: :noticed_notification do
    read_at { 2.days.ago }
  end

  factory :unread_noticed_notification, parent: :noticed_notification do
    read_at { nil }
  end
end
