require 'rubygems'
require 'grape'
require 'sinatra/activerecord'

require_relative '../helpers/authentication'
require_relative '../helpers/characters'

require_relative '../models/character'
require_relative '../models/user'

class Characters < Grape::API
	format :json

	resource :characters do
		helpers do
			params :auth_params do
				requires :fb_user_id, type: Integer
				requires :api_key, type: String
			end
		end

		after_validation do
			error!("User could not be authenticated.", 401) unless authenticated?(params[:fb_user_id], params[:api_key])
		end

		desc "Return static information on all characters available to the user"
		params do
			use :auth_params
		end
		get do
			status 200
			User.find(params[:fb_user_id]).characters
		end

		desc "Return static information on a single character available to the user"
		params do
			use :auth_params
			requires :character_id, type: Integer
		end
		route_param :character_id do
			get do
				error!("Character does not exist.", 404) unless character_exists?(params[:character_id])
				error!("Character is not available to user.", 403) unless character_unlocked?(params[:fb_user_id], params[:character_id])
				status 200
				Character.find(params[:character_id])
			end
		end
	end
end