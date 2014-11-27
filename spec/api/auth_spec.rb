require_relative "../spec_helper"
require 'multi_json'
describe '"CYOA::API"' do

	describe "POST /auth" do


		context "when user doesn't yet exist" do
			before do
				post_json('/v0.1/auth', {
					uid: "0000000",
					fb_token: "fb000000000"
					})
			end

			let(:status) { last_response.status }
			let(:parsed_json) { json_parse last_response.body }

			it 'responds with 201' do
				expect(status).to eql(201)
			end 

			it 'returns an app access token' do
				expect(parsed_json).to have_key(:token)
			end
		end

		context "when user already exists" do
			before do
				user = FactoryGirl.create(:user)
				FactoryGirl.create(:api_key)
				post_json('/v0.1/auth', FactoryGirl.attributes_for(:user))
			end

			let(:status) { last_response.status }
			let(:parsed_json) { json_parse last_response.body }

			it 'responds with 200' do
				expect(status).to eql(200)
			end
			it 'returns an app access token' do
				expect(parsed_json).to have_key(:token)
			end
		end


	end

end

# require_relative "../spec_helper"

# describe '"CYOA::Game::Player"' do
# 	before do
# 		@user = double('player')
# 		# @user.stub(:to_s => "my string")
# 		allow(@user).to receive(:to_s) {"my string"}
# 	end

# 	it "should return a string" do
# 		expect(@user.to_s).to eql("my string")
# 	end
# end