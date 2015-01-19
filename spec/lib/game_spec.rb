require_relative "../spec_helper"

describe CYOA::Game::Player do
# 	before do
# 		@user = double('player')
# 		# @user.stub(:to_s => "my string")
# 		allow(@user).to receive(:to_s) {"my string"}
# 	end

# 	it "should return a string" do
# 		expect(@user.to_s).to eql("my string")
# 	end

	let(:player) do
		mock_model "User"
	end

	it { expect(player).to respond_to (:name)}
end