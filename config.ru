require './api'
require './site'
require 'yaml'

env_file = File.join("config/environment_variables.yml")

if File.exists?(env_file)
	YAML.load_file(env_file)['development'].each do |key, value|
		ENV[key.to_s] = value.to_s
	end
end

use Rack::Session::Cookie, :secret => 'abc123'

use OmniAuth::Builder do
  provider :facebook, ENV['APP_ID'], ENV['APP_SECRET'], :scope => 'public_profile,email'
end

run Rack::Cascade.new [CYOA::API, Site]
