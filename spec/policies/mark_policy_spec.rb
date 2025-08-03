require 'rails_helper'

RSpec.describe MarkPolicy do
  let(:teacher) { create(:user, :teacher) }
  let(:student) { create(:user, :student) }
  let(:scope) { double('Scope') }
  let(:mark) { double('Mark') }

  describe 'Scope#resolve' do
    subject { described_class::Scope.new(user, scope) }

    context 'when user is a teacher' do
      let(:user) { teacher }
      it 'returns all marks' do
        expect(scope).to receive(:all)
        subject.resolve
      end
    end

    context 'when user is a student' do
      let(:user) { student }
      it 'returns marks for the user' do
        expect(scope).to receive(:where).with(user: user)
        subject.resolve
      end
    end
  end

  describe '#create?' do
    it 'allows teachers' do
      policy = described_class.new(teacher, mark)
      expect(policy.create?).to be true
    end
    it 'denies students' do
      policy = described_class.new(student, mark)
      expect(policy.create?).to be false
    end
  end

  describe '#update?' do
    it 'allows teachers' do
      policy = described_class.new(teacher, mark)
      expect(policy.update?).to be true
    end
    it 'denies students' do
      policy = described_class.new(student, mark)
      expect(policy.update?).to be false
    end
  end

  describe '#edit?' do
    it 'is the same as update?' do
      policy = described_class.new(teacher, mark)
      expect(policy.edit?).to eq(policy.update?)
    end
  end
end
