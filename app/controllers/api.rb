require 'dotenv'
Dotenv.load

require 'rubygems'
require 'grape' 
require 'json'
require 'sinatra/activerecord'


require_relative '../models/all'
#require_relative '../controllers/TODO'


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

		# content_type :json, "application/json"
		post "test" do
			params do
				requires :uid, type: Integer, desc: "Facebook user id."
				requires :fb_token, type: String, desc: "A valid Facebook access token."
			end
			params['uid']
		end

		helpers do
			def authenticate!
				error!('401 Unauthorized', 401) unless current_user
			end

			def current_user
				access_token = ''
				(/^Token token="(?<token>\w+)"*$/).match(headers['Authorization']) do |m|
					access_token = m[:token]
					puts m[:token]
				end

				token = ApiKey.find_by_access_token(access_token)
				if token
					@current_user = User.find(token.uid)
				else
					false
				end
			end

			def current_user=(user)
				@current_user = user
			end

			def facebook_token_valid?(token)
				# TODO: check validity of facebook token
				true
			end
		end

		resource :auth do
			params do
				requires :uid, type: Integer, desc: "Facebook user id."
				requires :fb_token, type: String, desc: "A valid Facebook access token."

				optional :first_name, type: String, desc: "User's first name."
				optional :last_name, type: String, desc: "User's last name."
				optional :email, type: String, desc: "User's email."
			end

			desc "Authenticate a user with a Facebook uid and access token"
			post do
				error!('400 Invalid Facebook token', 400) unless facebook_token_valid?(params['fb_token'])
				begin 
					user = User.find(params['uid'])
				rescue ActiveRecord::RecordNotFound
					user = User.new(
						:uid => params['uid'],
						:fb_token => params['fb_token'],
						:first_name => params['first_name'],
						:last_name => params['last_name'],
						:email => params['email']
						)

					if user.save
						ApiKey.create(:uid => params['uid'])
						token = ApiKey.find_by(:uid => params['uid']).access_token
						status 201
						return { :token => token }
					else
						puts "the user didn't save!" # TODO: handle this properly
					end
				end
				token = ApiKey.find_by(:uid => params['uid']).access_token
				status 200
				return { :token => token }
			end
		end

		resource :characters do
			# requires an app token parameter to access

			desc "Return all available character ids"
			get do
				# Hacky way to remove ids before returning
				# all_characters = Character.all
				# all_characters_hash = all_characters.as_json
				# all_characters_hash.each do |char|
				# 	char.delete("id")
				# end
				# all_characters_hash

				# calls all the characters that a user has access to
				return [{ character_id: "0", character_name: "Abba", character_age: 99, character_description: "Some person"},
						{ character_id: "1", character_name: "Bob", character_age: 64, character_description: "Another person"}]
			end

			desc "Return static information"
			get :unique_character_id do
				# return character specific informatione
			end

			desc "Return user progress information"
			get ":unique_character_id/progress" do

			end

			delete do
				# repopulate data to seed
			end

		end

		resource :scenes do
			# REQUIRES 
				# requires an app token parameter to access

			desc "Return available scene ids"
			get  do
				return [{ scene_id: "0", character_id: "0", scene_information: "Some information" },
						{ scene_id: "1", character_id: "1", scene_information: "Some information" }]
			end

			desc "Return scene information"
			get :scene_id do
			end

			delete do
				# repopulate data to seed
			end
		end

		resource :messages do
			# REQUIRES
				# a parameter corresponding to a scene id (optional) and character id (required)

			desc "Return all messages with a character"
			get "/" do
				# if a user already has a log
					# return all messages

				# else 
					# create a new empty store 
					# return first message(s)

				# if scene id specified, only return for that scene
				return [{ message_id: "0", scene_id: "0", message_text: "Hi there! I'm some text.", date_time: "01/01/11" },
						{ message_id: "1", scene_id: "0", message_text: "Yo.", date_time: "01/01/12" }]
			end

			desc "Updates user log and returns next messages" 
			put ":message_id/choices?id=:choice_id" do
				# update the store

				# returns the next message(s)
				return { message_id: "0", scene_id: "0", message_text: "Hi there! I'm some text.", date_time: "01/01/11", 
					choices: [{choice_id: 3, message_id: 1, choice_text: "This is a choice text", date_time: "null"},
								{choice_id: 4, message_id: 1, choice_text: "This is a choice text", date_time: "null"},
								{choice_id: 5, message_id: 1, choice_text: "This is a choice text", date_time: "null"}] }
			end

			delete do
				# repopulate data to seed
			end

		end

		resource :choices do

			get do
				return [{ choice_id: 0, message_id: 0, choice_text: "This is a choice text", date_time: "01/01/11" },
					{choice_id: 3, message_id: 1, choice_text: "This is a choice text", date_time: "null"},
					{choice_id: 4, message_id: 1, choice_text: "This is a choice text", date_time: "null"},
					{choice_id: 5, message_id: 1, choice_text: "This is a choice text", date_time: "null"}]
			end

			delete do
				# repopulate data to seed
			end

		end

	end
end
