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

		version 'v0.1', using: :param # so ?apiver=v0.1
		format :json

		helpers do

			def authenticate!
				# api_key = ApiKey.find_by_access_token(params[:access_token])
				error!('401 Unauthorized', 401) unless current_user
			end

			def current_user
				# Retreive token from headers
				access_token = ""

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

		get do
			authenticate!
			return "You've been authenticated!"
		end

		resource :authenticate do
			params do
				requires :uid, type: Integer, desc: "Facebook user id."
				requires :fb_token, type: String, desc: "A valid Facebook token."

				optional :first_name, type: String, desc: "User's first name."
				optional :last_name, type: String, desc: "User's last name."
				optional :email, type: String, desc: "User's email."
			end

			desc "Authenticate a user with a facebook uid and token"
			post do
				# first, check if the facebook token works!
				error!('400 Invalid Facebook token', 400) unless facebook_token_valid?(params['fb_token'])

				# then check if uid already exists
        		begin 
        			user = User.find(params['uid'])
        		rescue ActiveRecord::RecordNotFound
					# if no, 
					# this may be a brand new user
						# in which case, get the uid and fb_token from the user as request body
						# grab the data and create a new user
						# create an app token for the user
						# return the app token with a good response!
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
        				return { :token => token }.to_json
        			else
        				puts "the user didn't save!"
        			end
        		end

				# if yes,
				# or an existing user on a new device
					# also get the uid and fb_token from the user as request body
					# TODO: update the fb token on record
					# return the app token with a good response!

        		# Assuming there only exists one token for this uid
        		token = ApiKey.find_by(:uid => params['uid']).access_token
        		status 200
        		return { :token => token }.to_json

			end

		end

		resource :scenarios do

			desc "Return all available scenario ids"
			get do
				# return all_available_scenario_ids
				"all scenario ids"
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
