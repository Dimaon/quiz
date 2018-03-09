class Question
  attr_accessor :question, :seconds_to_answer, :answers

  def initialize(qa)
    @question = qa[:question]
    @answers = qa[:answers]
    @seconds_to_answer = qa[:seconds_to_answer]
  end

  def correct_answer
    @answers.key("true")
  end

  def answers_text
    answers = ""
    @answers.keys.each_with_index do |answer, index|
      answers << "#{index + 1}. #{answer}\n\r"
    end
    # Строка с ответами
    answers
  end
end