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
end