# client : the application a user uses to play the game

# client is responsible for:
	# user information (token, name)
	# scenario information (e.g. profiles, name, description)
 	# maintaining a local store of message history for each scenario

require 'faraday'

base_url = 'http://127.0.0.1'
port = '9393'

conn = Faraday.new(:url => base_url + ':' + port)

response = conn.get '/'
p response.body

# client logic

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

# on choosing scenario
	# if first time
		# send get request to '/scenarios/:unique_scenario_id/messages'
		# if user's first time on scenario
			# print first message
			# if children.choice.is_empty?
				# request next message
			# else
				# display choices
			# end
		# else
			# store message log in local database
			# print message log
		# end
	# else
		# print message log
		# if choices exist on last message
			# print choices
		# end
	# end

	# if choice selected
	# if delay passes
	# if scenario history deleted
