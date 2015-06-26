require 'dotenv'
Dotenv.load

require 'rubygems'
require 'httparty'
require 'json'

def fb_authenticated?(fb_user_id, fb_access_token)
	# # Verify user
	# response = HTTParty.get("https://graph.facebook.com/me", query: { access_token: fb_access_token })
	# json = JSON.parse(response.body)
	# return false if json['data']['user_id'] != fb_user_id
	# # Verify access to application
	# response = HTTParty.get("https://graph.facebook.com/app", query: { access_token: fb_access_token })
	# json = JSON.parse(response.body)
	# return false if json['data']['app_id'] != ENV['APP_ID']
	true
end