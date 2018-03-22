class Victorine
  attr_reader :questions_all
  attr_accessor :time_all, :late_answers_count, :incorrect_answers_count, :correct_answers_count

  def initialize(questions_all)
    @questions_all = questions_all
    @time_all = 0
    @correct_answers_count = 0
    @incorrect_answers_count = 0
    @late_answers_count = 0
  end

  # Парсим xml-документ, получаем многомерный хэш, где ключ - это вопрос,
  # а значение хэш, с ответами
  def self.parse_doc(doc)
    questions_all = []
    doc.root.elements.each("question") do |q|
      questions, answers = {},{}
      questions[:question] = q.elements["title"].text
      questions[:seconds_to_answer] = q.attributes["seconds"]

      q.elements.each("answers/answer") do |a|
        correct = a.attributes["correct"].to_s
        answer = a[0]
        answers[answer] = correct
      end

      questions[:answers] = answers
      questions_all << Question.new(questions)
      questions, answers = {}, {}
    end
    new(questions_all)
  end

  # Только один вопрос.
  def ask_question(current_question)
      puts "Вопрос: #{current_question.question}"
      puts "Время на ответ: #{current_question.seconds_to_answer} сек."
      puts "Варианты ответов: \n\r#{current_question.answers_text}"
  end

  # Результат викторины
  def result
    result = ""
    correct_answers_result = "\tПравильных ответов: #{correct_answers_count}\n\r"
    result << correct_answers_result
    incorrect_answers_result = "\tНе правильных ответов: #{incorrect_answers_count}\n\r"
    result << incorrect_answers_result
    time_spent_result = "\tПотрачено на тест: #{time_all.round(2)} сек.\n\r"
    result << time_spent_result
    late_answers_result = "\tОтветы на которые превышено время: #{late_answers_count}"
    result << late_answers_result
  end
end