require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  let(:user) { create(:user) }
  let!(:read_notification) { create(:read_noticed_notification, recipient: user) }
  let!(:unread_notification) { create(:unread_noticed_notification, recipient: user) }

  before { sign_in user }

  describe 'GET #index' do
    it 'assigns all notifications by default' do
      get :index
      expect(assigns(:notifications)).to include(read_notification, unread_notification)
    end

    it 'filters unread notifications' do
      get :index, params: { filter: 'unread' }
      expect(assigns(:notifications)).to include(unread_notification)
      expect(assigns(:notifications)).not_to include(read_notification)
    end

    it 'filters read notifications' do
      get :index, params: { filter: 'read' }
      expect(assigns(:notifications)).to include(read_notification)
      expect(assigns(:notifications)).not_to include(unread_notification)
    end
  end

  describe 'PATCH #update' do
    it 'marks notification as read and redirects back' do
      request.env['HTTP_REFERER'] = notifications_path
      patch :update, params: { id: unread_notification.id }
      expect(unread_notification.reload.read_at).not_to be_nil
      expect(response).to redirect_to(notifications_path)
    end
  end
end
