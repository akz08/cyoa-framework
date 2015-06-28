require 'rubygems'
require 'grape'
require 'sinatra/activerecord'

require_relative '../helpers/users'

require_relative '../models/api_key'
require_relative '../models/user'

class Users < Grape::API
	format :json

	resource :users do
		params do
			requires :fb_user_id, type: Integer
		end
		route_param :fb_user_id do
			desc "Authenticate a user by using a Facebook access token"
			params do
				requires :fb_access_token, type: String
				optional :first_name, type: String
				optional :last_name, type: String
				optional :email, type: String
			end
			post do
				error!("Access denied.", 401) unless fb_authenticated?(params['fb_user_id'], params['fb_access_token'])
				begin
					user = User.find(params[:fb_user_id])
					status 200
					{ key: user.key }
				rescue ActiveRecord::RecordNotFound
					user = User.create(
						fb_user_id: params[:fb_user_id],
						first_name: params[:first_name],
						last_name: params[:last_name],
						email: params[:email]
					)
					error!("400 Could not create user.", 400) unless user.valid?
					status 201
					{ key: user.key }
				end
			end
		end
	end
end