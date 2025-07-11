require 'rails_helper'

RSpec.describe Topic, type: :model do
  let(:course) { create(:course) }
  let(:topic) { create(:topic, course: course) }

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(5).is_at_most(50) }
    it { should validate_presence_of(:course) }
    it { should validate_numericality_of(:position).is_greater_than_or_equal_to(1) }
  end

  describe 'associations' do
    it { should belong_to(:course) }
    it { should have_many(:lessons).dependent(:destroy) }
  end

  describe 'topic creation' do
    it 'creates a valid topic with default attributes' do
      expect(topic).to be_valid
      expect(topic.title).to be_present
      expect(topic.course).to eq(course)
      expect(topic.position).to be >= 1
      expect(topic.position).to be <= 10
    end

    it 'creates a topic with a specific position' do
      topic = create(:topic, course: course, position: 2)
      expect(topic.position).to eq(2)
    end

    it 'cannot create a topic with a position less than 1' do
      topic = build(:topic, course: course, position: 0)
      expect(topic).not_to be_valid
      expect(topic.errors[:position]).to include("must be greater than or equal to 1")
    end

    it 'cannot create a topic with a title less than 5 characters' do
      topic = build(:topic, course: course, title: 'a' * 4)
      expect(topic).not_to be_valid
      expect(topic.errors[:title]).to include("is too short (minimum is 5 characters)")
    end

    it 'cannot create a topic with a title more than 50 characters' do
      topic = build(:topic, course: course, title: 'a' * 51)
      expect(topic).not_to be_valid
      expect(topic.errors[:title]).to include("is too long (maximum is 50 characters)")
    end

    it 'cannot create a topic with a title containing invalid characters' do
      topic = build(:topic, course: course, title: 'a' * 50 + '#')
      expect(topic).not_to be_valid
      expect(topic.errors[:title]).to include("contains invalid characters")
    end
  end
end
