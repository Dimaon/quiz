class Victorine
  attr_reader :questions_all, :time_all

  def initialize(doc)
    parse_doc(doc)
    @time_all = 0
    @correct_answers_count = 0
    @incorrect_answers_count = 0
    @late_answers_count = 0
  end

  def parse_doc(doc)
    @questions_all = []
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
      @questions_all << Question.new(questions)
      questions, answers = {}, {}
    end
  end

  def run
    questions_all.each do |q|
      puts "Вопрос: #{q.question}"
      puts "Время на ответ: #{q.seconds_to_answer} сек."
      puts "Варианты ответов: \n\r#{q.answers_text}"

      time_start = Time.now

      begin
        puts "Введите номер ответа от 1 до #{q.answers.size}: "
        user_answer = STDIN.gets.to_i
      end until user_answer > 0 && user_answer <= q.answers.size

      time_end = Time.now

      @time_all += (time_end - time_start)

      if q.seconds_to_answer.to_i <= (time_end - time_start).to_i
        puts "Время на ответ истелко. Ответ не засчитан"
        @late_answers_count += 1
        next
      else
        if q.answers.keys[user_answer - 1] == q.correct_answer.to_s
          puts "Верно"
          puts
          @correct_answers_count += 1
        else
          puts "Не верно. Правильный ответ: #{q.correct_answer}"
          @incorrect_answers_count += 1
        end
      end
    end
  end

  def result
    correct_answers_result = "\tПравильных ответов: #{@correct_answers_count}\n\r"
    incorrect_answers_result = "\tНе правильных ответов: #{@incorrect_answers_count}\n\r"
    time_spent_result = "\tПотрачено на тест: #{@time_all.round(2)} сек.\n\r"
    late_answers_result = "\tОтветы на которые превышено время: #{@late_answers_count}"
    correct_answers_result + incorrect_answers_result + time_spent_result + late_answers_result
  end
end