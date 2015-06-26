require 'rubygems'
require 'sinatra/activerecord'

require_relative '../models/api_key'

def authenticated?(fb_user_id, api_key)
	begin
		stored_key = ApiKey.find_by!("key = ? AND active = ?", api_key, true)
		if stored_key.fb_user_id == fb_user_id.to_i then true else false end
	rescue ActiveRecord::RecordNotFound
		false
	end
end