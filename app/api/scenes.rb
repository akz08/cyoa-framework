require 'dotenv'
Dotenv.load

require 'rubygems'
require 'grape'
require 'sinatra/activerecord'

require_relative '../models/character'
require_relative '../models/message'
require_relative '../models/scene'
require_relative '../models/user'

class Scenes < Grape::API
	format :json

	resource :scenes do
		helpers do
			def scene_exists?(scene_id)
				begin
					Scene.find(scene_id)
				rescue ActiveRecord::RecordNotFound
					false
				end
				true
			end

			def scene_unlocked?(fb_user_id, scene_id)
				begin
					User.find(fb_user_id).messages.where(scene_id: scene_id)
				rescue ActiveRecord::RecordNotFound
					false
				end
				true
			end
		end

		desc "Return static information of all scenes available to the user"
		get do
			scenes = []
			User.find(params[:fb_user_id]).messages.group(:scene_id).each do |message|
				scenes << message.scene
			end
			status 200
			scenes
		end

		# desc "Return static information on a single scene available to the user"
		# params do
		# 	requires :scene_id, type: Integer, desc: "Unique scene id."
		# end
		# route_param :scene_id do
		# 	get do
		# 		error!("Access denied.", 401) unless authorised?(params['fb_user_id'], params['fb_access_token'])
		# 		error!("Scene does not exist.", 400) unless scene_exists?(params['scene_id'])
		# 		error!("Scene is not available to user.", 403) unless scene_unlocked?(params['scene_id'])
		# 		#status 200
		# 		#Scene.find_by!(id: params['scene_id'])
		# 	end
		# end
	end
end