require 'factory_girl'
require 'sinatra'

set :environment, :test

require 'sinatra/activerecord'

require_relative '../../api/player_api'

FactoryGirl.find_definitions

# Disable ActiveRecord logging
ActiveRecord::Base.logger = nil

# Automigrate if necessary (since we're using the test environment)
if ActiveRecord::Migrator.needs_migration?
	ActiveRecord::Migrator.migrate(File.join('./', 'db/migrate'))
end

