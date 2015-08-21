require 'rubygems'
require 'grape'
require 'sinatra/activerecord'

require_relative '../helpers/authentication'

require_relative '../models/api_key'
require_relative '../models/character'
require_relative '../models/user'

class Users < Grape::API
	format :json

	resource :users do
		params do
			requires :fb_user_id, type: Integer
		end
		after_validation do
			@current_user = User.find_by(fb_user_id: params[:fb_user_id])
		end
		route_param :fb_user_id do
			desc "Authenticate a user via a Facebook access token"
			post do
				params do
					requires :fb_access_token, type: String
					optional :first_name, type: String
					optional :last_name, type: String
					optional :email, type: String
				end
				error!("User could not be authenticated via Facebook.", 401) unless fb_authenticated?(@current_user, params[:fb_access_token])
				if @current_user
					status 200
					@current_user.touch
				else
					@current_user = User.create(
						fb_user_id: params[:fb_user_id],
						first_name: params[:first_name],
						last_name: params[:last_name],
						email: params[:email]
					)
					error!("Could not create user.", 400) unless @current_user.valid?
					status 201
				end
				api_key = @current_user.api_keys.find_by(active: true).key
				{ api_key: api_key }
			end

			desc "Reset progress made by a user"
			put :reset do
				params do
					requires :api_key, type: String
				end
				error!("User could not be authenticated.", 401) unless authenticated?(@current_user, params[:api_key])
				@current_user.characters.clear
				Character.where(add_on: false).each do |character|
					@current_user.characters << character
				end
				status 204
				true
			end
		end
	end
end