require "rails_helper"

RSpec.describe ApplicationNotifier, type: :notifier do
  let(:recipient) { create(:user) }
  let(:message) { "Test notification message" }
  let(:url) { "/test/path" }

  let(:notification) do
    ApplicationNotifier.with(message: message, url: url).deliver(recipient)
    recipient.notifications.last
  end

  describe "#message" do
    it "returns the correct message from params" do
      expect(notification.params[:message]).to eq(message)
    end
  end

  describe "#url" do
    it "returns the correct url from params" do
      expect(notification.params[:url]).to eq(url)
    end
  end

  describe "#id" do
    it "returns the notification id" do
      expect(notification.id).to eq(notification.id)
    end
  end
end
