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

require 'json'

require 'io/console'
require 'watir-webdriver'

require 'faraday'
require 'faraday_middleware'

# Setup 
base_url = 'http://localhost'
port = '9393'

url = base_url + ':' + port

conn = Faraday.new(:url => url) do |faraday|
	faraday.request :json
	faraday.adapter Faraday.default_adapter
end

## client logic below

# Simulating use of the Facebook SDK on the phone
# puts "Please login via Facebook"
# puts "-------------------------"
# print "Email: "
# myLogin = gets.chomp
# print "Password (hidden): "
# myPassword = STDIN.noecho(&:gets).chomp

# temporary hardcode
myLogin = "open_wffbyeg_user@tfbnw.net"
myPassword = "koolaid"

browser = Watir::Browser.new
browser.goto url + '/server-side'
browser.text_field(:id => 'email').when_present.set myLogin
browser.text_field(:id => 'pass').when_present.set myPassword

browser.button(:name => 'login').when_present.click

# Simulate confirmation of permissions (if necessary)
if browser.form(:id => 'platformDialogForm').exists?
	puts ""
	puts "Automatically accepting permissions for you..."
	browser.button(:name => '__CONFIRM__').click

	Watir::Wait.until { (/callback\?code=/).match(browser.url) }
end

if (/callback\?code=/).match(browser.url)
	puts "Facebook login successful!"
	callback_json = browser.pre.inner_html
end

browser.close

# Client parses JSON and grabs user details and token
callback_hash = JSON.parse(callback_json)

uid = callback_hash["uid"]

info_hash = callback_hash["info"]
first_name = info_hash["first_name"]
last_name = info_hash["last_name"]
email = info_hash["email"]

credentials_hash = callback_hash["credentials"]
fb_token = credentials_hash["token"]

# Client then sends details to server to get the app token
auth_response = conn.post do |req|
	req.url '/authenticate'
	req.params['fb_token'] = fb_token
	req.params['uid'] = uid
end

if auth_response.status == 201
	puts "created new user!"
	puts auth_response.body
elsif auth_response.status == 200
	puts "authenticated current user!"
	puts auth_response.body
end

# # on application start

# scenario_ids = conn.get do |req|
# 	req.url '/scenarios'
# 	req.params['user_token'] = user_token
# end
# # if scenario_ids == local scenario_ids
# 	# ...
# # end

# # on scenario information selection

# scenario_information = conn.get do |req|
# 	req.url '/scenarios/' + unique_scenario_id
# 	req.params['user_token'] = user_token
# end
# # if scenario_information != local scenario_information
# 	# update local scenario_information
# # display scenario information

# # on scenario selection

# if first_time?(scenario_id)
# 	messages = conn.get '/scenarios/' + unique_scenario_id + '/messages'
# 	update_message_log(messages)
# 	display_messages(messages)
# else
# 	display_messages(message_log)
# end

# def display_messages(messages)
# 	# for each message in message log
# 		# if message is due
# 			# render message
# 			# if not last message in log
# 				# render choice made
# 			# else
# 				# display_choices(message)
# 			# end
# 		# end
# 	# end
# end

# def display_choices(message)
# end

# def choose(choice_id)
# 	# render choice
# 	# update message log
# 	conn.put do |req|
# 		req.url '/messages/' + message_id + '/choices/' + choice_id
# 		req.params['user_token'] = user_token
# 		req.params['scenario_id'] = scenario_id
# 	end
# 	next_messages = ... # as part of put request will receive the next message(s)
# 	display_messages(next_messages)
# end

