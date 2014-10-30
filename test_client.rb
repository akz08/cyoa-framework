require 'faraday'
require 'faraday_middleware'

def has_token?
end

def token_valid?
end

# SETUP URLS
# base_url = 'http://local.cyoa.com'
# port = '9393'
# conn = Faraday.new(:url => base_url + ':' + port)

# client first checks if has an app token

if has_token?
	# send a request to the server to see if the token is valid
	if token_valid?
		# continue on into the app and allow things to happen
	else
		# either the token expired or it's a malicious/malformed token
		# so perform local authentication via facebook process
	end

else # it doesn't have a token
	# initialise the facebook login sdk/redirect
end


# these calls should be done server-side
fbconn = Faraday.new "https://graph.facebook.com" do |conn|
	conn.request :oauth2, "token"
	conn.request :json

	conn.response :json, :content_type => /\bjson$/

	conn.adapter Faraday.default_adapter
end

response = fbconn.get '/v2.1/me?fields=id,name,email'
p response.body