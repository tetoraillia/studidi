require 'rails_helper'

RSpec.describe Option, type: :model do
  let(:option) { build(:option) }

  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_least(1).is_at_most(100) }
  it { should belong_to(:question) }

  it 'should be valid' do
    expect(option).to be_valid
  end

  it 'should not be valid without a title' do
    option.title = nil
    expect(option).not_to be_valid
  end

  it 'should not be valid without a question' do
    option.question = nil
    expect(option).not_to be_valid
  end

  it 'should not be valid with a title longer than 100 characters' do
    option.title = 'a' * 101
    expect(option).not_to be_valid
  end

  it 'should not be valid with a title shorter than 1 character' do
    option.title = 'a' * 0
    expect(option).not_to be_valid
  end
end
