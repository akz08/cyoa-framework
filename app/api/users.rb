require 'dotenv'
Dotenv.load

require 'rubygems'
require 'grape'
require 'httparty'
require 'sinatra/activerecord'

require_relative '../models/user'
require_relative '../models/api_key'

class Users < Grape::API
	format :json

	resource :users do
		helpers do
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
		end

		desc "Authenticate a user by using a Facebook access token"
		params do
			requires :fb_user_id, type: Integer
			requires :fb_access_token, type: String
			optional :first_name, type: String
			optional :last_name, type: String
			optional :email, type: String
		end
		post :authenticate do
			error!("Access denied.", 401) unless fb_authenticated?(params[:fb_user_id], params[:fb_access_token])
			begin
				User.find(params[:fb_user_id])
			rescue ActiveRecord::RecordNotFound
				user = User.create(
					fb_user_id: params[:fb_user_id],
					first_name: params[:first_name],
					last_name: params[:last_name],
					email: params[:email]
				)
				if user.valid?
					key = ApiKey.create(fb_user_id: params[:fb_user_id]).key
					status 201
					return { key: key }
				else
					error!("400 Could not create user.", 400)
				end
			end
			status 200
		end
	end
end