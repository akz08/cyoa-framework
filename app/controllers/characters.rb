require 'rubygems'
require 'grape'
require 'sinatra/activerecord'

require_relative '../helpers/authentication'
require_relative '../helpers/characters'

require_relative '../models/character'
require_relative '../models/message'
require_relative '../models/scene'
require_relative '../models/user'

class Characters < Grape::API
	format :json

	params do
		requires :fb_user_id, type: Integer
		requires :api_key, type: String
	end
	after_validation do
		error!("User could not be authenticated.", 401) unless authenticated?(params[:fb_user_id], params[:api_key])
	end
	resource :characters do
		desc "Return static information on all characters available to the user"
		get do
			status 200
			{ characters: User.find(params[:fb_user_id]).characters }
		end

		params do
			requires :character_id, type: Integer
		end
		after_validation do
			error!("Character does not exist.", 404) unless character_exists?(params[:character_id])
			error!("Character is not available to user.", 403) unless character_unlocked?(params[:fb_user_id], params[:character_id])
		end
		route_param :character_id do
			desc "Return static information on a single character available to the user"
			get do
				status 200
				{ character: User.find(params[:fb_user_id]).characters.find(params[:character_id]) }
			end

			desc "Return static information on all available scenes, for a single character available to the user"
			get :scenes do
				status 200
				{ scenes: User.find(params[:fb_user_id]).scenes.where(character_id: params[:character_id]) }
			end
		end
	end
end