require 'rubygems'
require 'httparty'
require 'sinatra/activerecord'

require_relative '../models/message'
require_relative '../models/message_scene_dependency'
require_relative '../models/scene'
require_relative '../models/user'

def add_successive_character_messages_to_block(block)
	message = block.last
	while message && message.from_character do
		block << message
		message = message.children.first
	end
	block
end

def get_character_response(user_message)
	character_response = [ user_message.children.first ]
	add_successive_character_messages_to_block(character_response)
end

def get_first_messages_in_scene(scene)
	first_messages_in_scene = [ scene.message.first ]
	add_successive_character_messages_to_block(first_messages_in_scene)
end

def message_sent_valid?(user, message)
	if user && message && !message.from_character && user.scenes.include?(message.scene)
		previous_message = user.messages.where(scene_id: message.scene.id).last
		message.parent.id == previous_message.id
	else
		false
	end
end

def send_via_gcm(user, message)
	# TODO: via method described in developer docs
	true
end

def trigger_next_scene(user, message)
	next_scene = message.dependent_scene
	user.scenes << next_scene
	next_scene_character_messages = get_first_messages_in_scene(next_scene)
	next_scene_character_messages.each do |message|
		@current_user.messages << message
	end
	first_messages_in_scene = { character_messages: next_scene_character_messages, user_choices: next_scene_character_messages.last.children }
	send_via_gcm(user, first_messages_in_scene)
end