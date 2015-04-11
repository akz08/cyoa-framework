class Character

	attr_accessor :id, :name, :age, :description

	def initialize(character, user_message)
		@character = character
		@user_message = user_message
	end

	def get_information
		# Returns all fields in JSON format

		# construct new JSON object
		# add each field to JSON object
		# return JSON object
	end

	def get_static_information

	end

	def get_progress
		
	end

end

class Game

	

end

class Player

	attr_accessor :user

	def initialize(user)
		@user = user
	end

	def get_all_available_characters
		# Returns JSON for all characters available to player

		characters = @user.characters
		# initialise JSON object containing array
		# for each character object:
		# => instantiate new character object
		# => character.get_information
		# => add JSON object to array
		# return array
	end

end
