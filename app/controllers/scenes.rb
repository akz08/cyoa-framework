require 'rubygems'
require 'grape'
require 'sinatra/activerecord'

require_relative '../helpers/authentication'
require_relative '../helpers/characters'
require_relative '../helpers/scenes'

require_relative '../models/character'
require_relative '../models/message'
require_relative '../models/scene'
require_relative '../models/user'

class Scenes < Grape::API
	format :json

	params do
		requires :fb_user_id, type: Integer
		requires :api_key, type: String
	end
	after_validation do
		error!("User could not be authenticated.", 401) unless authenticated?(params[:fb_user_id], params[:api_key])
	end
	resource :scenes do
		desc "Return static information on all scenes available to the user"
		get do
			status 200
			{ scenes: User.find(params[:fb_user_id]).scenes }
		end

		params do
			requires :scene_id, type: Integer
		end
		after_validation do
			error!("Scene does not exist.", 404) unless scene_exists?(params[:scene_id])
			error!("Scene is not available to user.", 403) unless scene_unlocked?(params[:fb_user_id], params[:scene_id])
		end
		route_param :scene_id do
			desc "Return static information on a single scene available to the user"
			get do
				status 200
				{ scene: User.find(params[:fb_user_id]).scenes.find(params[:scene_id]) }
			end

			desc "Return static information on all exchanged messages, for a single scene available to the user"
			get :messages do
				status 200
				{ messages: User.find(params[:fb_user_id]).messages.where(scene_id: params[:scene_id]) }
			end
		end
	end
end