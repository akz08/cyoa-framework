require 'rubygems'
require 'sinatra' 
require 'json'

get '/' do
  "It runs from Heroku!"
end

get '/messages/next' do
	return {:message => "A message!"}.to_json
end

