require "rexml/document"
require_relative "lib/question"
require_relative "lib/victorine"

file = File.new(__dir__ + "/data/qa.xml")

abort "File not found" unless File.exist?(file)

doc = REXML::Document.new(file)

victorine = Victorine.new(doc)

victorine.run

result = victorine.result

puts
puts "Рассчитываем результат: "
sleep 2

puts result
