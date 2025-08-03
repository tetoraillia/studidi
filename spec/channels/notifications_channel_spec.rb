require 'rails_helper'

RSpec.describe NotificationsChannel, type: :channel do
  let(:user) { create(:user) }

  before do
    stub_connection current_user: user
  end

  it 'subscribes to a stream when user is authenticated' do
    subscribe
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("noticed:notification:notifications_#{user.id}")
  end

  it 'does not subscribe to a stream when user is not authenticated' do
    stub_connection current_user: nil
    subscribe
    expect(subscription).to be_rejected
  end
end
