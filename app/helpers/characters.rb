require 'rubygems'
require 'sinatra/activerecord'

require_relative '../models/character'
require_relative '../models/user'

def character_exists?(character_id)
	begin
		Character.find(character_id)
		true
	rescue ActiveRecord::RecordNotFound
		false
	end
end

def character_unlocked?(fb_user_id, character_id)
	begin
		User.find(fb_user_id).characters.find(character_id)
		true
	rescue ActiveRecord::RecordNotFound
		false
	end
end