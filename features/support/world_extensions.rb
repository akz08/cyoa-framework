require 'rack/test'

module KnowsAboutApi
	def app
		CYOA::API
	end
end

World(KnowsAboutApi, Rack::Test::Methods)
