require 'rubygems'
require 'httparty'
require 'sinatra/activerecord'

require_relative '../models/message'
require_relative '../models/message_scene_dependency'
require_relative '../models/scene'
require_relative '../models/user'

def compute_character_response(user, message)
	response = []
	message = message.children.first
	while message && message.from_character do
		user.messages << message
		response << message
		message = message.children.first
	end
	response
end

def sent_message_valid?(user, message)
	if user && message && !message.from_character && user.scenes.include?(message.scene)
		previous_message = user.messages.where(scene_id: message.scene.id).last
		message.parent.id == previous_message.id
	else
		false
	end
end

def send_message_via_gcm(user, message)
	# TODO: via method described in developer docs
	true
end

def trigger_next_scene(user, message)
	next_scene = message.dependent_scene
	user.scenes << next_scene
	next_message = next_scene.messages.first
	user.messages << next_message
	send_message_via_gcm(user, next_message)
end