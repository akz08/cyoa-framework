require 'rubygems'
require 'httparty'
require 'sinatra/activerecord'

require_relative '../models/character'
require_relative '../models/message'
require_relative '../models/message_scene_dependency'
require_relative '../models/scene'
require_relative '../models/user'

def trigger_next_scene_from_message(user, message)
	next_scene = message.dependent_scene
	user.scenes << next_scene
	next_message = next_scene.messages.first
	user.messages << next_message
	# TODO: send next_message to user via GCM
	true
end