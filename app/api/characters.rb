require 'dotenv'
Dotenv.load

require 'rubygems'
require 'grape'
require 'sinatra/activerecord'

require_relative '../models/character'
require_relative '../models/message'
require_relative '../models/scene'
require_relative '../models/user'

class Characters < Grape::API
	format :json

	resource :characters do
		helpers do
			def character_exists?(character_id)
				begin
					Character.find(character_id)
				rescue ActiveRecord::RecordNotFound
					false
				end
				true
			end

			def character_unlocked?(fb_user_id, character_id)
				begin
					User.find(fb_user_id).characters.find(character_id)
				rescue ActiveRecord::RecordNotFound
					false
				end
				true
			end
		end

		desc "Return static information on all characters available to the user"
		get do
			status 200
			User.find(params[:fb_user_id]).characters
		end

		desc "Return static information on a single character available to the user"
		params do
			requires :character_id, type: Integer
		end
		route_param :character_id do
			get do
				error!("Character does not exist.", 400) unless character_exists?(params[:character_id])
				error!("Character is not available to user.", 403) unless character_unlocked?(params[:fb_user_id], params[:character_id])
				status 200
				User.find(params[:fb_user_id]).characters.find(params[:character_id])
			end
		end

		desc "Return exchanged messages for a single character available to the user"
		params do
			requires :character_id, type: Integer
		end
		route_param :character_id do
			get 'progress' do
				error!("Character does not exist.", 400) unless character_exists?(params[:character_id])
				error!("Character is not available to user.", 403) unless character_unlocked?(params[:fb_user_id], params[:character_id])
				progress = []
				User.find(params[:fb_user_id]).messages.each do |message|
					if message.scene.character.id = params[:character_id]
						progress << message
					end
				end
				status 200
				progress
			end
		end
	end
end