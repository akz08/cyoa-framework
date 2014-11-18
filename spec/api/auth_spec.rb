require_relative "../spec_helper"

describe '"CYOA::API"' do

	describe "POST /auth" do

		context "when user already exists" do
			it 'responds with 200' 
			it 'returns an app access token'
		end

		context "when user doesn't yet exist" do
			it 'responds with 201'
			it 'returns an app access token'
		end

	end

end