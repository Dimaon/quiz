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
    questions = {}
    answers = {}
    @questions_all = []
    doc.root.elements.each("question") do |q|
      questions[:question] = q.elements["title"].text
      questions[:seconds_to_answer] = q.attributes["seconds"]

      q.elements.each("answers/answer") do |a|
        correct = a.attributes["correct"].to_s
        answer = a[0]
        answers[answer] = correct
      end

      questions[:answers] = answers
      @questions_all << Question.new(questions)
      answers = {}
      questions = {}
    end
  end

  def run
    questions_all.each do |q|
      puts q.question

      time_start = Time.now
      user_answer = STDIN.gets.chomp
      time_end = Time.now
      @time_all += (time_end - time_start)
      correct_user_anwer = (user_answer == q.correct_answer.to_s)

      if q.seconds_to_answer.to_i <= (time_end - time_start).to_i
        puts "Время на ответ истелко. Ответ не засчитан"
        @late_answers_count += 1
        next
      else
        if correct_user_anwer
          puts "Верно"
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
    time_spent_result = "\tПотрачено на тест: #{@time_all} сек.\n\r"
    late_answers_result = "\tОтветы на которые превышено время: #{@late_answers_count}"
    correct_answers_result + incorrect_answers_result + time_spent_result + late_answers_result
  end
end