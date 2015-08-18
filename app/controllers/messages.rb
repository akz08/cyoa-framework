require 'rubygems'
require 'grape'
require 'sinatra/activerecord'

require_relative '../helpers/authentication'
require_relative '../helpers/post_message'

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

			desc "Verify and associate the user and their response to a character message"
			post do
				error!("Message cannot be sent by user.", 403) unless message_sent_valid?(@current_user, @message)
				@current_user.messages << @message
				status 201
				character_messages = get_character_response(@message)
				if character_messages.present?
					character_messages.each do |message|
						@current_user.messages << message
					end
					user_choices = character_messages.last.children
					if user_choices.present?
						{ character_messages: character_messages, user_choices: user_choices }
					else
						trigger_next_scene(@current_user, character_messages.last)
						{ character_messages: character_messages, user_choices: nil }
					end
				else
					trigger_next_scene(@current_user, @message)
					{ character_messages: nil, user_choices: nil }
				end
			end
		end
	end
end