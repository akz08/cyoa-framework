require 'dotenv'
Dotenv.load

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

		get '/test' do 
			@user = User.new
			@user.uid = 'test'
			@user.fb_token = 'test token'
			@user.save
		end

		get do
			# return "it works on heroku!"
			authenticate!
			@current_user
		end

		resource :register do
			# deal with a user registering with a uid and facebook token

			# check if uid already exists

			# if no, 
			# this may be a brand new user
				# in which case, get the uid and fb_token from the user as request body
				# test to see if the fb token works
				# double check the uid matches (may not be needed...)
				# grab the data and create a new user
				# create an app token for the user
				# return the app token with a good response!

			# if yes,
			# or an existing user on a new device
				# also get the uid and fb_token from the user as request body
				# test to see if the fb token works
				# if it does, update the fb token on record
				# retun the app token with a good response!

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
