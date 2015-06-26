require 'dotenv'
Dotenv.load

require 'rubygems'
require 'grape'

require_relative './characters'
#require_relative './messages'
require_relative './scenes'
require_relative './users'

class API < Grape::API
	version 'v0.1', using: :path
	format :json

	mount Characters
	mount Scenes
	#mount Messages
	mount Users
end