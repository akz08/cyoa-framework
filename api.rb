require 'rubygems'
require 'sinatra' 
require 'json'

get '/' do
  "It runs from Heroku!"
end

get '/messages/next' do
	return {:message => "A message!"}.to_json
end

# API sends 'message' as :
	# message_id
	# text
	# delay (of current message)
	# children (message_id, choice)

# when a client app opens a "game scenario" for the first time
get '/scenarios/:unique_scenario_id/messages' do
	# get from request body 'first_time' (boolean)

 	# if user's first time 
 		# create a new record (table) for this particular scenario
 		# insert scenario's first message into the table
 		# return first message 
 	# elsif user already played scenario
 		# return the message log and next message
 	# end
end

post '/scenarios/:unique_scenario_id/messages/:message_id/choices/:choice_id' do

	# update the user's scenario log in table

	# return next message

end