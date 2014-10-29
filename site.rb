require 'sinatra'
require 'omniauth-facebook'

class Site < Sinatra::Base

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
            xfbml  : true , // parse XFBML
            version: 'v2.1'
          });
        };

        (function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "//connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));

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
            }, { scope: 'public_profile', state: 'abc123' });
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

  # redirect '/auth/:provider/callback'
end

get '/auth/:provider/callback' do
  content_type 'application/json'
  p env['omniauth.auth']
  MultiJson.encode(request.env['omniauth.auth'])
end

get '/auth/failure' do
  content_type 'application/json'
  MultiJson.encode(request.env)
end
end