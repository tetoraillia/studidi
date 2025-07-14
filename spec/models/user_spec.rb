require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password).on(:create) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'associations' do
    it { should have_many(:enrollments).dependent(:destroy) }
    it { should have_many(:enrolled_courses).through(:enrollments) }
  end

  describe 'user creation' do
    it 'creates a valid user with default attributes' do
      expect(subject).to be_valid
      expect(subject.first_name).to be_present
      expect(subject.last_name).to be_present
      expect(subject.email).to be_present
      expect(subject.password).to be_present
    end

    it 'creates a user with a specific role' do
      user = create(:user, role: 'teacher')
      expect(user.role).to eq('teacher')
    end

    it 'cannot create a user with an invalid role' do
      user = build(:user, role: 'invalid_role')
      expect(user).not_to be_valid
      expect(user.errors[:role]).to include("is not included in the list")
    end
  end
end
