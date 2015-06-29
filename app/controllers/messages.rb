require 'rubygems'
require 'grape'
require 'sinatra/activerecord'

require_relative '../helpers/authentication'
require_relative '../helpers/post_message_valid'
require_relative '../helpers/trigger_next_scene'

require_relative '../models/message'
require_relative '../models/user'

class Messages < Grape::API
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
	resource :messages do
		desc "Return static information on all messages available to the user"
		get do
			status 200
			{ messages: @current_user.messages }
		end

		params do
			requires :message_id, type: Integer
		end
		after_validation do
			@message = Message.find_by(id: params[:message_id])
			error!("Message does not exist.", 404) unless @message
		end
		route_param :message_id do
			desc "Return static information on a single message available to the user"
			get do
				error!("Message is not available to user.", 403) unless @current_user.messages.include?(@message)
				status 200
				{ message: @message }
			end

			desc "Process the message sent by the user in response to a character message"
			post do
				error!("Message cannot be posted by user.", 403) unless post_message_valid?(@current_user, @message)
				@current_user.messages << @message
				character_response = @message.children.first
				if character_response
					@current_user.messages << character_response
					choices = character_response.children
					trigger_next_scene(character_response) if choices.empty?
					status 201
					{ character_response: character_response, choices: choices }
				else
					trigger_next_scene(@message)
					status 201
					{ character_response: nil, choices: nil }
				end
			end
		end
	end
end