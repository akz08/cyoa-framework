require 'rubygems'
require 'sinatra/activerecord'

require_relative '../models/message'
require_relative '../models/scene'
require_relative '../models/user'

def post_message_valid?(user, message)
	return false unless user && message
	return false if message.from_character
	return false unless user.scenes.include?(message.scene)
	previous_message = user.messages.where(scene_id: message.scene.id).last
	true unless message.parent.id != previous_message.id
end