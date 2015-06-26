require 'rubygems'
require 'grape'
require 'sinatra/activerecord'

require_relative '../helpers/authentication'
require_relative '../helpers/characters'
require_relative '../helpers/scenes'

require_relative '../models/scene'
require_relative '../models/user'

class Scenes < Grape::API
	format :json

	resource :scenes do
		helpers do
			params :auth_params do
				requires :fb_user_id, type: Integer
				requires :api_key, type: String
			end
		end

		after_validation do
			error!("User could not be authenticated.", 401) unless authenticated?(params[:fb_user_id], params[:api_key])
		end

		desc "Return static information on all available scenes, for a single character available to the user"
		params do
			use :auth_params
			requires :character_id, type: Integer
		end
		get do
			error!("Character does not exist.", 404) unless character_exists?(params[:character_id])
			error!("Character is not available to user.", 403) unless character_unlocked?(params[:fb_user_id], params[:character_id])
			status 200
			User.find(params[:fb_user_id]).scenes
		end

		desc "Return static information on a single available scene, for a single character available to the user"
		params do
			use :auth_params
			requires :scene_id, type: Integer
		end
		route_param :scene_id do
			get do
				error!("Scene does not exist.", 404) unless scene_exists?(params[:scene_id])
				error!("Scene is not available to user.", 403) unless scene_unlocked?(params[:fb_user_id], params[:scene_id])
				status 200
				Scene.find(params[:scene_id])
			end
		end
	end
end