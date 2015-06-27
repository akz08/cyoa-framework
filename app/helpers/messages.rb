require 'rubygems'
require 'httparty'
require 'sinatra/activerecord'

require_relative './scenes'

require_relative '../models/character'
require_relative '../models/message'
require_relative '../models/scene'
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

def post_message_valid?(fb_user_id, message_id)
	begin
		message = Message.find(message_id)
		return false if message.from_character
		return false unless scene_exists?(message.scene.id)
		return false unless scene_unlocked?(fb_user_id, message.scene.id)
		previous_message = User.find(fb_user_id).messages.where(scene_id: message.scene.id).last
		true unless message.parent.id != previous_message.id
	rescue
		false
	end
end

def trigger_next_scene(message_id)
	# TODO
	true
end