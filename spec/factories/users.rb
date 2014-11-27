FactoryGirl.define do 

	factory :user do
		uid "0000000000"
		fb_token "fbtoken000"
		first_name "Bob"
		last_name "Smith"
		email "bob@smith.com"
	end
	
	factory :api_key do
		uid "0000000000"
		access_token "app-access-token"
	end
end
