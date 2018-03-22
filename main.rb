require "rexml/document"
require_relative "lib/question"
require_relative "lib/victorine"

file = File.new(__dir__ + "/data/qa.xml")

abort "File not found" unless File.exist?(file)

doc = REXML::Document.new(file)

victorine = Victorine.parse_doc(doc)

# Здесь должны быть обьекты класса Question
questions_all = victorine.questions_all

questions_all.each do |current_question|
  victorine.ask_question(current_question)

  time_start = Time.now

  user_answer = ""
  loop do
    puts "Введите номер ответа от 1 до #{current_question.answers.size}: "
    user_answer = STDIN.gets.to_i
    break if user_answer > 0 && user_answer <= current_question.answers.size
  end

  time_end = Time.now

  victorine.time_all += (time_end - time_start)

  if current_question.seconds_to_answer.to_i <= (time_end - time_start).to_i
    puts "Время на ответ истелко. Ответ не засчитан"
    victorine.late_answers_count += 1
    next
  else
    if current_question.answers.keys[user_answer - 1] == current_question.correct_answer.to_s
      puts "Верно"
      puts
      victorine.correct_answers_count += 1
    else
      puts "Не верно. Правильный ответ: #{current_question.correct_answer}"
      victorine.incorrect_answers_count += 1
    end
  end
end

puts
puts "Рассчитываем результат: "
result = victorine.result

sleep 2

puts result
