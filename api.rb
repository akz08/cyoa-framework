require 'rubygems'
require 'sinatra' 
require 'json'

get '/' do
  "It runs from Heroku!"
end

### MOBILE CLIENT API

# API sends 'message' as :
	# message_id
	# text
	# delay (of current message)
	# children (message_id, choice)

# ALL routes below require a user token parameter (so linked to an account)

get '/scenarios' do
	# return all_available_scenario_ids
end

get '/scenarios/:unique_scenario_id' do
	# return scenario specific information
end

# only called by the client when first time opening a scenario
get '/scenarios/:unique_scenario_id/messages' do
	# if a user already has a log
		# return all messages

	# else 
		# create a new empty store 
		# return first message(s)
end

put '/messages/:message_id/choices/:choice_id' do
	# REQUIRES
		# a paramater corresponding to a scenario id

	# update the store

	# returns the next message(s)
end