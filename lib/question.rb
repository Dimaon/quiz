class Question
  attr_accessor :question, :seconds_to_answer

  def initialize(qa)
    @question = qa[:question]
    @answers = qa[:answers]
    @seconds_to_answer = qa[:seconds_to_answer]
  end

  def correct_answer
    @answers.key("true")
  end
end