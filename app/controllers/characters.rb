require 'rubygems'
require 'grape'
require 'sinatra/activerecord'

require_relative '../helpers/authentication'

require_relative '../models/character'
require_relative '../models/scene'
require_relative '../models/user'

class Characters < Grape::API
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
	resource :characters do
		desc "Return static information on all characters available to the user"
		get do
			status 200
			{ characters: @current_user.characters }
		end

		params do
			requires :character_id, type: Integer
		end
		after_validation do
			@character = Character.find_by(id: params[:character_id])
			error!("Character does not exist.", 404) unless @character
		end
		route_param :character_id do
			desc "Return static information on a single character available to the user"
			get do
				error!("Character is not available to user.", 403) unless @current_user.characters.include?(@character)
				status 200
				{ character: @character }
			end

			desc "Unlock a character for a user"
			post do
				error!("Character has already been unlocked by user.", 403) if @current_user.characters.include?(@character)
				@current_user.characters << @character
				status 201
				{ character: @character }
			end

			desc "Return static information on all available scenes, for a single character available to the user"
			get :scenes do
				error!("Character is not available to user.", 403) unless @current_user.characters.include?(@character)
				status 200
				{ scenes: @current_user.scenes.where(character_id: @character.id) }
			end
		end
	end
end