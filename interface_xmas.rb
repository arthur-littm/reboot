require 'open-uri'
require 'nokogiri'
require 'csv'

def scrape(keyword)
  # 1. We get the HTML page content thanks to open-uri
  html_content = open("https://www.etsy.com/search?q=#{keyword}").read
  # 2. We build a Nokogiri document from this file
  doc = Nokogiri::HTML(html_content)

  results = []
  # 3. We search for the correct elements containing the items' title in our HTML doc
  doc.search('.block-grid-xs-2 .v2-listing-card__info .text-body').first(5).each do |element|
    # 4. For each item found, we extract its title and print it
    results << element.text.strip
  end
  return results
end

# 1. add `mark` as an option in the menu
# 2. list all the gifts from `gift_list` and modify the display
# 3. ask the user which to mark as bought (index)
# 4. find the right gift in the `gift_list`
# 5. change the value of `bought` to `true` for that gift


gift_list = []
filepath = "gifts.csv"

CSV.foreach(filepath) do |row|
  name = row[0]
  bought = row[1] == "true"
  # if row[1] == "true"
  #   bought = true
  # else
  #   bought = false
  # end
  gift_list << {name: name, bought: bought}
end

puts "> Welcome to your Christmas gift list"

answer = ""

while answer != "quit"
  puts "> Which action [list|add|delete|mark|idea|quit]?"
  answer = gets.chomp
  case answer
  when "list"
    puts "Gift List"
    gift_list.each_with_index do |item, index|
      marked = item[:bought] ? 'X' : ' '
      puts "#{index + 1} [#{marked}] - #{item[:name]}"
    end

  when "idea"

    puts "What are you searching on Etsy?"
    article = gets.chomp

    results = scrape(article)

    results.each_with_index do |gift, index|
      puts "#{index + 1} - #{gift}"
      puts "---------"
    end

    puts "pick one (index)?"
    index_to_add = gets.chomp.to_i - 1

    add_gift = results[index_to_add]
    gift_list << {name: add_gift, bought: false}

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

  when "mark"

    puts "Gift List"
    gift_list.each_with_index do |item, index|
      marked = item[:bought] ? 'X' : ' '
      puts "#{index + 1} [#{marked}] - #{item[:name]}"
    end
    puts "Which item have you bought (give the index)?"

    mark = gets.chomp.to_i - 1
    if gift_list[mark].nil?
      puts "wrong number mate"
    else
      gift_list[mark][:bought] = true
    end

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
