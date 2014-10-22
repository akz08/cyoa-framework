class Message
	attr_reader :parent
	attr_accessor :text

	class ExistingParentException < Exception
	end

	class NoChildrenException < Exception
	end

	def to_s
		"-->".red + "\n" +
		"text: #{@text}" + "\n" + 
		"Parent: #{@parent}" + "\n" +
		"Children: #{@children}"
	end

	def initialize(args)
		@text = args[:text]
		@parent = nil
		@children = []
	end

	Child = Struct.new(:message, :choice)

	# two cases of setting a parent
	# 1. setting a parent of a new message
	# 2. changing the parent of a message (need to remove as child)
	def set_parent(parent)
		if @parent != nil
			raise ExistingParentException
		else
			@parent = parent
		end
	end

	def set_parent!(parent)

		if @parent != nil 
			@parent.remove_child(self)
		end

		@parent = parent
	end

	protected :set_parent, :set_parent!

	def add_child(child_message, user_choice=nil)
		child_message.set_parent(self)

		@children << Child.new(child_message, user_choice)
	end

	# note: this may mess up the indexing of child messages and choices!
	# takes in the choice index to remove the Child
	def remove_child(child_message, user_choice=nil)
		@children.each do |child|
			if child.message == child_message && child.choice == user_choice
				@children.delete(child)
			end
		end

		# some error handling here
	end

	def delete!
		# perform things to delete it from persistent store
		# ...

		# after deleting itself, it removes all references to it in the parent
		@parent.each do |child|
			if child.message == self
				@parent.remove_child(self, child.choice)
			end
		end
	end

	def children
		@children #.collect { |child| child.message }
	end

	def has_choices?
		# returns boolean on presence of choices
		choices.each { |choice| return true if choice != nil }
		return false
	end

	def choices
		# return an array of choices
		@children.collect { |child| child.choice }
	end

	# METHODS BELOW GO TO A MESSAGE MANAGER
	# def choose_response(index)
	# 	if index > children.length
	# 		raise IndexError
	# 	elsif @children.empty?
	# 		raise NoChildrenException
	# 	else
	# 		@children[index] # !!!!!!!!!!!!!!!!! expects an index to match
	# 	end
	# end

	# def next
	# 	choose_response(0)
	# end
end

class Game

	def initialize(args)
		@name = args[:name]
		@description = args[:description] || ''
		@current_msg = nil
		@user = args[:user] || User.new(:name => 'Sammy')
	end

	def start

		# Create messages
		msg0 = Message.new(:text => "Hmm...")
		msg1 = Message.new(:text => "Hi there!")
		msg2 = Message.new(:text => "What's your name?")

		msg3 = Message.new(:text => "That's a great name!")
		msg4 = Message.new(:text => "You don't fool me! Your name is actually NAME!")
		msg5 = Message.new(:text => "But it's cool all the same...")

		# Link up messages
		msg0.add_child(msg1)
		msg1.add_child(msg2, 'Hi!')
		msg2.add_child(msg3, "It's Bob")
		msg2.add_child(msg4, "It's Zbdfiosf")

		@current_msg = msg0
		loop do
			# puts @current_msg.text
			print_message(@current_msg)

			break if @current_msg.children.empty?
			if @current_msg.has_choices?
				puts @current_msg.choices
				user_choice = gets.chomp.to_i
				@current_msg = @current_msg.children[user_choice].message
			else
				@current_msg = @current_msg.children[0].message
			end

		end
	end

	## THIS SHOULD BE SOMEWHERE ELSE!
	def print_message(message)
		processed_msg = message.text.gsub(/NAME/, @user.name)
		puts processed_msg
	end

end

class User
	attr_accessor :name

	def initialize(args)
		@name = args[:name] || "Bob"
	end

end

