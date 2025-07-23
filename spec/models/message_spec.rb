require 'rails_helper'

RSpec.describe Message, type: :model do
  it "has a valid factory" do
    expect(build(:message)).to be_valid
  end

  context "validations" do
    it "validates content length" do
      message = build(:message, content: "a" * 301)
      expect(message).not_to be_valid
      expect(message.errors[:content]).to include("is too long (maximum is 300 characters)")
    end

    it "validates content presence" do
      message = build(:message, content: nil)
      expect(message).not_to be_valid
      expect(message.errors[:content]).to include("can't be blank")
    end

    it "validates user presence" do
      message = build(:message, user: nil)
      expect(message).not_to be_valid
      expect(message.errors[:user]).to include("must exist")
    end
  end

  context "associations" do
    it "belongs to a user" do
      message = build(:message)
      expect(message).to belong_to(:user)
    end
  end

  scenario "create message" do
    expect { create(:message) }.to change(Message, :count).by(1)
  end
end
