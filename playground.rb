require_relative 'game'

# 1

# # puts "Creating new messages...".green.underline
# msg1_1 = Message.new(:text => 'What is your name?')

# msg1_2 = Message.new(:text => 'Are you guy or girl?')
# msg2_1 = Message.new(:text => 'So you are a girl')
# msg2_2 = Message.new(:text => 'So you are a guy')

# # puts "Adding children...".green.underline
# msg1_2.add_child(msg2_1, "I'm a girl")
# msg1_2.add_child(msg2_2, "I'm a guy")
# puts msg1_2.children
# # puts msg1_2.option_keys?

# puts "Checking parents...".green.underline
# puts msg2_1.parent
# puts msg2_2.parent

# puts "Traversing down a parent".green.underline
# first_message = msg1_2
# # game_response = msg1_2.choose(0.to_s.to_sym)

# puts first_message.text
# puts "Please choose:".blue
# msg1_2.children.keys.each { |key| puts key.to_s.red + ": #{msg1_2.user_responses[key]}"}
# answer = gets.chomp
# puts msg1_2.choose(answer.to_sym).text

# 2

# # Create messages
# msg0 = Message.new(:text => "Hmm...")
# msg1 = Message.new(:text => "Hi there!")
# msg2 = Message.new(:text => "What's your name?")

# msg3 = Message.new(:text => "That's a great name!")
# msg4 = Message.new(:text => "That's a horrible name!")
# msg5 = Message.new(:text => "But it's cool all the same...")

# # Link up messages
# msg0.add_child(msg1)
# msg1.add_child(msg2, 'Hi!')
# msg2.add_child(msg3, "It's Bob")
# msg2.add_child(msg4, "It's Zbdfiosf")
# # use clone because each message can only have one parent
# # we assume that each choice, whilst may share the same text, will have different properties
# msg3.add_child(msg5.clone) 
# msg4.add_child(msg5)

# current_message = msg0

# loop do
# 	p current_message.text
# 	chosen_index = 0

# 	if current_message.has_choices?
# 		current_message.choices.each_with_index do |choice, index| 

# 			# list the available choices
# 			item = "#{index}: #{choice}"
# 			puts item.red

# 		end

# 		# give the user the opportunity to choose
# 		print "Response no.: "
# 		chosen_index = gets.chomp.to_i
# 	end

# 	break if current_message.children.empty?

# 	if chosen_index == 0
# 		current_message = current_message.next
# 	else 
# 		current_message = current_message.choose_response(chosen_index)
# 	end
	
# end

# 3

game = Game.new(:name => 'A new game')

game.start