require "rexml/document"
require_relative "lib/question"

file = File.new(__dir__ + "/data/qa.xml")

abort "File not found" unless File.exist?(file)

doc = REXML::Document.new(file)

questions = {}
answers = {}
questions_all = []

doc.root.elements.each("question") do |q|
  questions[:question] = q.attributes["question"]
  questions[:seconds_to_answer] = q.attributes["seconds"]
  q.elements.each("answer") do |a|
    correct = a.attributes["correct"].to_s
    answer = a[0]
    answers[answer] = correct
  end
  questions[:answers] = answers
  questions_all << Question.new(questions)
  answers = {}
  questions = {}
end

questions_all.each do |q|
  puts q.question
  time_start = Time.now
  user_answer = STDIN.gets.chomp
  time_end = Time.now
  if q.seconds_to_answer.to_i <= (time_end - time_start).to_i
    puts "Время на ответ истелко"
    next
  else
    if user_answer == q.correct_answer.to_s
      puts "Верно"
    else
      puts "Не верно. Правильный ответ: #{q.correct_answer}"
    end
  end
end
