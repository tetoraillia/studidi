class QuizMarkCalculator
  def initialize(lesson, user)
    @lesson = lesson
    @user = user
  end

  def call
    total_questions = @lesson.questions.count
    return if total_questions.zero?

    correct_answers = 0
    @lesson.questions.each do |question|
      response = Response.find_by(user: @user, responseable: question)
      next unless response

      correct_option = question.options.find_by(is_correct: true)
      correct_answers += 1 if correct_option && response.content == correct_option.id.to_s
    end

    score = (correct_answers.to_f / total_questions * 100).round

    mark = Mark.find_or_initialize_by(
      user: @user,
      lesson: @lesson
    )

    mark.update!(
      value: score,
      comment: "Quiz score: #{score}% (#{correct_answers}/#{total_questions} correct)"
    )

    mark
  end
end
