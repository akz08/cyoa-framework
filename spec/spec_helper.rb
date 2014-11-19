ENV['RACK_ENV'] = 'test'

require "database_cleaner"
require "factory_girl"
FactoryGirl.definition_file_paths = %w{./factories ./test/factories ./spec/factories}
FactoryGirl.find_definitions
Dir[File.dirname(__FILE__)+"/support/*.rb"].each {|file| require file }

require "rspec"
require "rack/test"
require "sinatra"
require "sinatra/activerecord"
	
require_relative "../api/player_api"

# Automigrate if necessary (since we're using the test environment)
if ActiveRecord::Migrator.needs_migration?
	ActiveRecord::Migrator.migrate(File.join('./', 'db/migrate'))
end

# JSON helpers

def get_json(path)
	get path
	json_parse(last_response.body)
end

def post_json(url, data)
	post(url, json(data), "CONTENT_TYPE" => "application/json")
	json_parse(last_response.body)
end

def put_json(url, data)
	put(url, json(data), "CONTENT_TYPE" => "application/json")
	json_parse(last_response.body)
end

def json_parse(body)
	MultiJson.load(body, symbolize_keys: true)
end

def json(hash)
	MultiJson.dump(hash, pretty: true)
end

def app
	CYOA::API
end

# Configure RSpec and FactoryGirl

RSpec.configure do |config|
	config.include Rack::Test::Methods

	config.color = true

	config.before(:suite) do
		DatabaseCleaner.strategy = :transaction
		DatabaseCleaner.clean_with :transaction

	end

	config.before(:each) do
		DatabaseCleaner.start
	end

	config.after(:each) do
		DatabaseCleaner.clean
	end
end

FactoryGirl.register_strategy(:json, JsonStrategy)