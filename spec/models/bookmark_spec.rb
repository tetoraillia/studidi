require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  let(:user) { create(:user) }
  let(:course) { create(:course) }

  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:course_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:course) }
  end
end
