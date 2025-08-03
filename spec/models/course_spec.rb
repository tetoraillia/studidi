require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:instructor) { create(:user, :teacher) }
  let(:course) { create(:course, instructor: instructor) }

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:instructor) }

    it 'validates title length' do
      course = build(:course, title: 'a' * 4)
      expect(course).not_to be_valid
      expect(course.errors[:title]).to include("is too short (minimum is 5 characters)")
    end

    it 'validates description length' do
      course = build(:course, description: 'a' * 9)
      expect(course).not_to be_valid
      expect(course.errors[:description]).to include("is too short (minimum is 10 characters)")
    end
  end

  describe 'associations' do
    it { should belong_to(:instructor).class_name('User') }
    it { should have_many(:topics).dependent(:destroy) }
    it { should have_many(:enrollments).dependent(:destroy) }
    it { should have_many(:students).through(:enrollments).source(:user) }
    it { should have_many(:invitations).dependent(:destroy) }
    it { should have_many(:lessons).through(:topics) }
  end

  describe 'public/private functionality' do
    context 'when course is public' do
      let(:public_course) { create(:course, :public) }

      it 'is accessible by default' do
        expect(public_course.public).to be true
      end
    end

    context 'when course is private' do
      let(:private_course) { create(:course, :private) }

      it 'is not accessible by default' do
        expect(private_course.public).to be false
      end
    end
  end

  describe 'course creation' do
    it 'creates a valid course with default attributes' do
      expect(course).to be_valid
      expect(course.title).to be_present
      expect(course.description).to be_present
      expect(course.instructor).to eq(instructor)
    end

    it 'creates a private course' do
      private_course = create(:course, :private)
      expect(private_course.public).to be false
    end

    it 'creates a public course' do
      public_course = create(:course, :public)
      expect(public_course.public).to be true
    end
  end
end
