require 'dotenv'
Dotenv.load

require 'rubygems'
require 'httparty'
require 'json'

require_relative '../models/api_key'
require_relative '../models/user'

def authenticated?(user, api_key)
	if user then user.api_keys.where(active: true).pluck(:key).include?(api_key) else false end
end

def fb_authenticated?(user, fb_access_token)
	# # Verify user identity
	# response = HTTParty.get("https://graph.facebook.com/me", query: { access_token: fb_access_token })
	# json = JSON.parse(response.body)
	# return false if json['data']['user_id'] != user.fb_user_id
	# # Verify access to application
	# response = HTTParty.get("https://graph.facebook.com/app", query: { access_token: fb_access_token })
	# json = JSON.parse(response.body)
	# return false if json['data']['app_id'] != ENV['APP_ID']
	true
end