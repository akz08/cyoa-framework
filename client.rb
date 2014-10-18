require 'faraday'

base_url = 'http://127.0.0.1'
port = '9393'

conn = Faraday.new(:url => base_url + ':' + port)

response = conn.get '/'
p response.body