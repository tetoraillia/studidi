require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  let(:user) { create(:user) }

  context 'when user is not authenticated' do
    it 'rejects unauthorized connection' do
      warden_mock = double("Warden", user: nil)
      stub_connection(env: { "warden" => warden_mock })

      expect {
        connect '/cable'
      }.to raise_error(ActionCable::Connection::Authorization::UnauthorizedError)
    end
  end
end
