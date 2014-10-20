require 'colorize'

class Message
	attr_reader :text, :parent

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
		@parent = args[:parent] || nil
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

	def add_child(child_message, user_choice=nil)
		child_message.set_parent(self)

		@children << Child.new(child_message, user_choice)
	end

	# note: this may mess up the indexing of child messages and choices!
	def remove_child(child_message)
		@children.each do |child|
			if child.message == child_message
				@children.delete(child)
			end
		end
	end

	def children
		@children.collect { |child| child.message }
	end

	def choices
		# return an array of choices
		@children.collect { |child| child.choice }
	end

	def has_choices?
		# returns boolean on presence of choices
		choices.each { |choice| return true if choice != nil }
		return false
	end

	def choose_response(index)
		if children.empty?
			raise NoChildrenException
		elsif index.nil?
			children.first
		else
			children[index]
		end
	end

	def next
		choose_response(nil)
	end
end

class User
	attr_accessor :name

	def initialize(args)
		@name = args[:name] || "Bob"
	end

end

