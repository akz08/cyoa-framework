require 'rubygems'
require 'grape'
require 'sinatra/activerecord'

require_relative '../helpers/authentication'
require_relative '../helpers/characters'
require_relative '../helpers/messages'
require_relative '../helpers/scenes'

require_relative '../models/character'
require_relative '../models/message'
require_relative '../models/scene'
require_relative '../models/user'

class Messages < Grape::API
	format :json

	params do
		requires :fb_user_id, type: Integer
		requires :api_key, type: String
	end
	after_validation do
		error!("User could not be authenticated.", 401) unless authenticated?(params[:fb_user_id], params[:api_key])
	end
	resource :messages do
		desc "Return static information on all messages available to the user"
		get do
			status 200
			User.find(params[:fb_user_id]).messages
		end

		params do
			requires :message_id, type: Integer
		end
		after_validation do
			error!("Message does not exist.", 404) unless message_exists?(params[:message_id])
			error!("Message is not available to user.", 403) unless message_exchanged?(params[:fb_user_id], params[:message_id])
		end
		route_param :message_id do
			desc "Return static information on a single message available to the user"
			get do
				status 200
				User.find(params[:fb_user_id]).messages.find(params[:message_id])
			end
		end
	end
end