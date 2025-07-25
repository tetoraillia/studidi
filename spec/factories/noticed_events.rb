FactoryBot.define do
  factory :noticed_event, class: 'Noticed::Event' do
    type { 'Noticed::Event' }
    record_type { 'User' }
    record_id { create(:user).id }
    params { {} }
  end
end
