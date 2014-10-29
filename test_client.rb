require 'faraday'

base_url = 'http://local.cyoa.com'
port = '9393'

conn = Faraday.new(:url => base_url + ':' + port)


