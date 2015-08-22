require 'dotenv'
Dotenv.load

require 'rubygems'
require 'grape'

require_relative './characters'
require_relative './messages'
require_relative './scenes'
require_relative './users'

class API < Grape::API
	format :json

	mount Characters
	mount Messages
	mount Scenes
	mount Users
end