module CYOA
	module Game
		class Player
			attr_reader :user

			def self.find(id)
				User.find(id)
			end

			def initialize(user)
				@user = user
			end

			def available_characters

			end
		end

		class Session

		end

		class Character

			def initialize(character)
				# set the activerecord model
				@character = character
			end

		end

	end
end