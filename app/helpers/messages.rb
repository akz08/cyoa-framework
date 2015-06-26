require 'rubygems'
require 'sinatra/activerecord'

require_relative '../models/message'
require_relative '../models/user'

def message_exists?(message_id)
	begin
		Message.find(message_id)
		true
	rescue ActiveRecord::RecordNotFound
		false
	end
end

def message_exchanged?(fb_user_id, message_id)
	begin
		User.find(fb_user_id).messages.find(message_id)
		true
	rescue ActiveRecord::RecordNotFound
		false
	end
end