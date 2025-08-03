require 'rails_helper'

RSpec.describe Lesson, type: :model do
  let(:topic) { create(:topic) }
  let(:lesson) { create(:lesson, topic: topic) }

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:topic) }
    it { should validate_numericality_of(:position).is_greater_than_or_equal_to(1) }
  end

  describe 'associations' do
    it { should belong_to(:topic) }
  end

  describe 'lesson creation' do
    it 'creates a valid lesson with default attributes' do
      expect(lesson).to be_valid
      expect(lesson.title).to be_present
      expect(lesson.content).to be_present
      expect(lesson.topic).to eq(topic)
    end

    it 'creates a lesson with a specific position' do
      lesson = create(:lesson, position: 2)
      expect(lesson.position).to eq(2)
    end

    it 'cannot create a lesson with an invalid position' do
      lesson = build(:lesson, position: 0)
      expect(lesson).not_to be_valid
      expect(lesson.errors[:position]).to include("must be greater than or equal to 1")
    end
  end

  describe "video_url validation" do
    it "requires video_url when content_type is video" do
      lesson = build(:lesson, content_type: "video", video_url: "")
      expect(lesson).not_to be_valid
      expect(lesson.errors[:video_url]).to include("can't be blank")
    end

    it "requires content when content_type is not video" do
      lesson = build(:lesson, content_type: "text", content: "")
      expect(lesson).not_to be_valid
      expect(lesson.errors[:content]).to include("can't be blank")
    end

    it "not requires content when content_type is test" do
      lesson = build(:lesson, content_type: "video", video_url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ", content: "")
      expect(lesson).to be_valid
    end

    it "does not require video_url when content_type is not video" do
      lesson = build(:lesson, content_type: "text", video_url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")
      expect(lesson).to be_valid
    end
  end
end
