module Responses
  class SubmitQuizAnswers
    def self.call(lesson:, user:, params:, topic:, course:)
      lesson.questions.each do |question|
        Response.create_or_find_by(
          user: user,
          responseable: question
        ).update!(content: params[:answers][question.id.to_s])
      end

      QuizMarkCalculator.new(lesson, user).call
    end
  end
end
