require 'rubygems'
require 'sinatra/activerecord'

require_relative '../models/scene'
require_relative '../models/user'

def scene_exists?(scene_id)
	begin
		Scene.find(scene_id)
		true
	rescue ActiveRecord::RecordNotFound
		false
	end
end

def scene_unlocked?(fb_user_id, scene_id)
	begin
		User.find(fb_user_id).scenes.find(scene_id)
		true
	rescue ActiveRecord::RecordNotFound
		false
	end
end