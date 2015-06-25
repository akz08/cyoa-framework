require 'dotenv'
Dotenv.load

require 'rubygems'
require 'grape'
require 'sinatra/activerecord'

require_relative './characters'
# require_relative './messages'
require_relative './scenes'
require_relative './users'

class API < Grape::API
	version 'v0.1', using: :path
	format :json

	mount Users

	helpers do
		def authenticated?(fb_user_id, api_key)
			begin
				stored_key = User.find(fb_user_id).api_keys.find_by!("key = ? AND active = ?", api_key, true)
				if stored_key.fb_user_id == fb_user_id then true else false end
			rescue ActiveRecord::RecordNotFound
				false
			end
		end
	end

	before do
		params do
			requires :fb_user_id, type: Integer
			requires :api_key, type: String
		end
		params[:fb_user_id] = params[:fb_user_id].to_i
		params[:api_key] = params[:api_key].to_s
		error!("User could not be authenticated.", 401) unless authenticated?(params[:fb_user_id], params[:api_key])
	end

	mount Characters
	# mount Messages
	mount Scenes
end