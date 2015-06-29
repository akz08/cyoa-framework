require 'rubygems'
require 'grape'
require 'sinatra/activerecord'

require_relative '../helpers/authentication'

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
		@current_user = User.find_by(fb_user_id: params[:fb_user_id])
		error!("User does not exist.", 404) unless @current_user
		error!("User could not be authenticated.", 401) unless authenticated?(@current_user, params[:api_key])
	end
	resource :scenes do
		desc "Return static information on all scenes available to the user"
		get do
			status 200
			{ scenes: @current_user.scenes }
		end

		params do
			requires :scene_id, type: Integer
		end
		after_validation do
			@scene = Scene.find_by(id: params[:scene_id])
			error!("Scene does not exist.", 404) unless @scene
			error!("Scene is not available to user.", 403) unless @current_user.scenes.include?(@scene)
		end
		route_param :scene_id do
			desc "Return static information on a single scene available to the user"
			get do
				status 200
				{ scene: @scene }
			end

			desc "Return static information on all exchanged messages, for a single scene available to the user"
			get :messages do
				status 200
				{ messages: @current_user.messages.where(scene_id: @scene.id) }
			end
		end
	end
end