require 'colorize'

class Message
	attr_reader :text, :parent, :children, :user_responses

	def to_s
		"-->".red + "\n" +
		"text: #{@text}" + "\n" + 
		"Parent: #{@parent}" + "\n" +
		"Children: #{@children}"
	end

	def initialize(args)
		@text = args[:text]
		@parent = args[:parent] || nil
		@children = args[:children] || {}
		@user_responses = {}
	end

	def set_parent(parent)
		@parent = parent
	end

	def add_child(child, user_response=nil)
		child.set_parent(self)
		if child.is_a? Message 
			generated_key = @children.count.to_s.to_sym
			@children[generated_key] = child
			@user_responses[generated_key] = user_response
		end
	end

	def options?
		children.keys
	end

	def choose(key)
		children[key]
	end
end

puts "Creating new messages...".green.underline
msg1_1 = Message.new(:text => 'What is your name?')
msg1_2 = Message.new(:text => 'Are you guy or girl?')
msg2_1 = Message.new(:text => 'So you are a girl')
msg2_2 = Message.new(:text => 'So you are a guy')

puts "Adding children...".green.underline
msg1_2.add_child(msg2_1, "I'm a girl")
msg1_2.add_child(msg2_2, "I'm a guy")
puts msg1_2.children
puts msg1_2.options?

puts "Checking parents...".green.underline
puts msg2_1.parent
puts msg2_2.parent

puts "Traversing down a parent".green.underline
first_message = msg1_2
# game_response = msg1_2.choose(0.to_s.to_sym)

puts first_message.text
puts "Please choose:".blue
msg1_2.children.keys.each { |key| puts key.to_s.red + ": #{msg1_2.user_responses[key]}"}
answer = gets.chomp
puts msg1_2.choose(answer.to_sym).text