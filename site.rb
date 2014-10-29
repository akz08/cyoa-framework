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

	# client-side flow
get '/client-side' do
  content_type 'text/html'
  # NOTE: When you enable cookie below in the FB.init call the GET request in the FB.login callback will send a signed
  #       request in a cookie back the OmniAuth callback which will parse out the authorization code and obtain an
  #       access_token with it.
  <<-END
    <html>
    <head>
      <title>Client-side Flow Example</title>
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.min.js" type="text/javascript"></script>
    </head>
    <body>
      <div id="fb-root"></div>

      <script type="text/javascript">
        window.fbAsyncInit = function() {
          FB.init({
            appId  : '#{ENV['APP_ID']}',
            status : true, // check login status
            cookie : true, // enable cookies to allow the server to access the session
            xfbml  : true  // parse XFBML
          });
        };

        (function(d) {
          var js, id = 'facebook-jssdk'; if (d.getElementById(id)) {return;}
          js = d.createElement('script'); js.id = id; js.async = true;
          js.src = "//connect.facebook.net/en_US/all.js";
          d.getElementsByTagName('head')[0].appendChild(js);
        }(document));

        $(function() {
          $('a').click(function(e) {
            e.preventDefault();

            FB.login(function(response) {
              if (response.authResponse) {
                $('#connect').html('Connected! Hitting OmniAuth callback (GET /auth/facebook/callback)...');

                // since we have cookies enabled, this request will allow omniauth to parse
                // out the auth code from the signed request in the fbsr_XXX cookie
                $.getJSON('/auth/facebook/callback', function(json) {
                  $('#connect').html('Connected! Callback complete.');
                  $('#results').html(JSON.stringify(json));
                });
              }
            }, { scope: 'email,read_stream', state: 'abc123' });
          });
        });
      </script>

      <p id="connect">
        <a href="#">Connect to FB!</a>
      </p>

      <p id="results" />
    </body>
    </html>
  END
end

get '/auth/:provider/callback' do
  content_type 'application/json'
  MultiJson.encode(request.env)
end

get '/auth/failure' do
  content_type 'application/json'
  MultiJson.encode(request.env)
end
end