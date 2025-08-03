require 'rails_helper'

RSpec.describe QuizMarkCalculator, type: :service do
  let(:user) { create(:user, :student) }
  let(:lesson) { create(:lesson) }
  let(:question) { create(:question, lesson: lesson) }
  let(:correct_option) { create(:option, question: question, is_correct: true) }

  describe '#call' do
    context 'when there are no questions' do
      let(:empty_lesson) { create(:lesson) }

      it 'returns nil' do
        expect(QuizMarkCalculator.new(empty_lesson, user).call).to be_nil
      end
    end

    context 'when there are questions with responses' do
      before do
        question
        create(:response, user: user, responseable: question, content: correct_option.id.to_s)
      end

      it 'calculates the score and creates a mark' do
        expect { QuizMarkCalculator.new(lesson, user).call }.to change(Mark, :count).by(1)
        mark = Mark.last
        expect(mark.value).to eq(100)
        expect(mark.comment).to eq("Quiz score: 100% (1/1 correct)")
      end
    end
  end
end
