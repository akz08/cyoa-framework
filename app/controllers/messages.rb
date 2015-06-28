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
			{ messages: User.find(params[:fb_user_id]).messages }
		end

		params do
			requires :message_id, type: Integer
		end
		after_validation do
			error!("Message does not exist.", 404) unless message_exists?(params[:message_id])
		end
		route_param :message_id do
			desc "Return static information on a single message available to the user"
			get do
				error!("Message is not available to user.", 403) unless message_exchanged?(params[:fb_user_id], params[:message_id])
				status 200
				{ message: User.find(params[:fb_user_id]).messages.find(params[:message_id]) }
			end

			desc "Process the message sent by the user in response to a character message"
			post do
				error!("Message cannot be posted by user.", 403) unless post_message_valid?(params[:fb_user_id], params[:message_id])
				user = User.find(params[:fb_user_id])
				message = Message.find(params[:message_id])
				user.messages << message
				character_response = message.children.first
				if !character_response.nil?
					user.messages << character_response
					choices = character_response.children
					trigger_next_scene(character_response.id) if choices.empty?
					status 201
					{ character_response: character_response, choices: choices }
				else
					trigger_next_scene(params[:message_id])
					status 201
					{ character_response: nil, choices: nil }
				end
			end
		end
	end
end