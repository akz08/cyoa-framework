# client : the application a user uses to play the game

# client is responsible for:
	# user information (token, name)
	# scenario information (e.g. profiles, name, description)
 	# maintaining a local store of message history for each scenario

# information stored by client
# user_token: string
# user_name: string
# scenario_information: object?
	# scenario_id: integer
	# name: string
	# description: string
	# scenario_first_time: boolean
# message_log: database records
	# message_id
	# message_text
	# choice_text
# current_message_delay: number

require 'faraday'

base_url = 'http://127.0.0.1'
port = '9393'

conn = Faraday.new(:url => base_url + ':' + port)

# testing out the base connection
response = conn.get '/'
p response.body

## client logic below

# on application start

scenario_ids = conn.get do |req|
	req.url '/scenarios'
	req.params['user_token'] = user_token
end
# if scenario_ids == local scenario_ids
	# ...
# end

# on scenario information selection

scenario_information = conn.get do |req|
	req.url '/scenarios/' + unique_scenario_id
	req.params['user_token'] = user_token
end
# if scenario_information != local scenario_information
	# update local scenario_information
# display scenario information

# on scenario selection

if first_time?(scenario_id)
	messages = conn.get '/scenarios/' + unique_scenario_id + '/messages'
	update_message_log(messages)
	display_messages(messages)
else
	display_messages(message_log)
end

def display_messages(messages)
	# for each message in message log
		# if message is due
			# render message
			# if not last message in log
				# render choice made
			# else
				# display_choices(message)
			# end
		# end
	# end
end

def display_choices(message)
end

def choose(choice_id)
	# render choice
	# update message log
	conn.put do |req|
		req.url '/messages/' + message_id + '/choices/' + choice_id
		req.params['user_token'] = user_token
		req.params['scenario_id'] = scenario_id
	end
	next_messages = ... # as part of put request will receive the next message(s)
	display_messages(next_messages)
end

