require 'csv'

gift_list = []
filepath = "gifts.csv"

CSV.foreach(filepath) do |row|
  name = row[0]
  bought = row[1]
  gift_list << {name: name, bought: bought}
end

puts "> Welcome to your Christmas gift list"

answer = ""

while answer != "quit"
  puts "> Which action [list|add|delete|quit]?"
  answer = gets.chomp
  case answer
  when "list"
    puts "Gift List"
    gift_list.each_with_index do |item, index|
      puts "#{index + 1} - #{item[:name]}"
    end


  when "add"
    puts "New gift item"
    add_gift = gets.chomp
    gift_list << {name: add_gift, bought: false}

  when "delete"
    puts "Gift List"
    gift_list.each_with_index do |item, index|
      puts "#{index + 1} - #{item[:name]}"
    end

    puts 'Which item do you want to delete? Type the correct index'
    item_to_delete = gets.chomp.to_i - 1
    name = gift_list[item_to_delete][:name]
    gift_list.delete_at(item_to_delete)
    puts "#{name} was deleted from the list"

  when "quit"
    puts "Goodbye 😃"

    CSV.open(filepath, 'wb') do |csv|
      gift_list.each do |gift|
        csv << [ gift[:name], gift[:bought] ]
      end
    end


  else
    puts "Error!"
  end
end
