require 'sinatra'
require 'omniauth-facebook'

class Site < Sinatra::Base
	use Rack::Session::Cookie
	use OmniAuth::Strategies::Facebook

	get '/'  do
		# ENV["RACK_ENV"]
	end

	get '/server-side' do

		redirect '/auth/Facebook'
	end
end