require 'rubygems'
require 'grape' 
require 'json'


### MOBILE CLIENT API

# API sends 'message' as :
	# message_id
	# text
	# delay (of current message)
	# children (message_id, choice)

# ALL routes below require a user token parameter (so linked to an account)

module CYOA
	class API < Grape::API

		version 'v0.1'
		format :json

		get do
			return "it works on heroku!"
		end

		resource :characters do

			desc "Return all available character ids"
			get do
				# return all_available_character_ids
			end

			desc "Return static information"
			get :unique_character_id do
				# return character specific information
			end

			desc "Return user progress information"
			get ":unique_character_id/progress" do

			end

			# only called by the client when first time opening a character
			desc "Return all messages with a character"
			get ":unique_character_id/messages" do
				# if a user already has a log
					# return all messages

				# else 
					# create a new empty store 
					# return first message(s)
			end

		end

		resource :scenes do
			# REQUIRES 
				# a parameter corresponding to character id

			desc "Return available scene ids"
			get  do
			end
		end

		resource :messages do

			desc "Return ..." 
			get ":message_id/choices/:choice_id" do
				# REQUIRES
					# a parameter corresponding to a scene id and character id

				# update the store

				# returns the next message(s)
			end

		end

	end
end
