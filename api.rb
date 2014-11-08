require 'rubygems'
require 'grape' 
require 'json'
# require 'sinatra/base'
require 'sinatra/activerecord'

require_relative 'models/init'

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

		helpers do

			def authenticate!
				# api_key = ApiKey.find_by_access_token(params[:access_token])
				error!('401 Unauthorized', 401) unless current_user
			end

			def current_user
				# access_token = params[:access_token]
				access_token = headers['Authorization']
				token = ApiKey.find_by_access_token(access_token)
				if token
					@current_user = User.find(token.user_id)
				else
					false
				end
			end

		end

		get do
			# return "it works on heroku!"
			authenticate!
			@current_user
		end

		resource :scenarios do

			desc "Return all available scenario ids"
			get do
				# return all_available_scenario_ids
			end

			desc "Return static information"
			get :unique_scenario_id do
				# return scenario specific information
			end

			desc "Return user progress information"
			get ":unique_scenario_id/progress" do

			end

			# only called by the client when first time opening a scenario
			desc "Return all messages in a user's scenario"
			get ":unique_scenario_id/messages" do
				# if a user already has a log
					# return all messages

				# else 
					# create a new empty store 
					# return first message(s)
			end

		end

		resource :acts do
			# REQUIRES 
				# a parameter corresponding to scenario id

			desc "Return available act ids"
			get  do
			end
		end

		resource :messages do

			desc "Return ..." 
			get ":message_id/choices/:choice_id" do
				# REQUIRES
					# a parameter corresponding to a act id

				# update the store

				# returns the next message(s)
			end

		end

	end
end
