require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { build(:question) }

  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_least(5).is_at_most(200) }
  it { should belong_to(:lesson) }

  it 'should be valid' do
    expect(question).to be_valid
  end

  it 'should not be valid without a title' do
    question.title = nil
    expect(question).not_to be_valid
  end

  it 'should not be valid without a lesson' do
    question.lesson = nil
    expect(question).not_to be_valid
  end

  it 'should not be valid with a title longer than 200 characters' do
    question.title = 'a' * 201
    expect(question).not_to be_valid
  end

  it 'should not be valid with a title shorter than 1 character' do
  question.title = 'a' * 0
  expect(question).not_to be_valid
end
end
