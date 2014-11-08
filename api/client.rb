# client : the application a user uses to play the game

# client is responsible for:
	# user information (token, name)
	# character information (e.g. profiles, name, description)
 	# maintaining a local store of message history for each character

# information stored by client
# user_token: string
# user_name: string
# character_information: object?
	# character_id: integer
	# name: string
	# age: integer
	# description: string
	# current_message_delay: number
# message_log: database records
	# message_id
	# message_text
	# choice_id
	# choice_text

require 'faraday'

base_url = 'http://127.0.0.1'
port = '9393'

conn = Faraday.new(:url => base_url + ':' + port)

# testing out the base connection
response = conn.get '/'
p response.body

## client logic below

# on application start

character_ids = conn.get do |req|
	req.url '/characters'
	req.params['user_token'] = user_token
end
# if character_ids == local character_ids
	# ...
# end

# on character information selection (sometimes...)

character_information = conn.get do |req|
	req.url '/characters/' + unique_character_id
	req.params['user_token'] = user_token
end
# if character_information != local character_information
	# update local character_information
# display character information

# on character conversation selection

if first_time?(character_id) # otherwise, data will be local!
	messages = conn.get '/messages'
	# send with character id
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

# when selecting a choice

def choose(choice_id)
	# render choice
	# update message log
	next_messages = conn.put do |req|
		req.url '/messages/' + message_id + '/choices?id=' + choice_id
		req.params['user_token'] = user_token
		req.params['character_id'] = character_id
	end
	display_messages(next_messages)
end

