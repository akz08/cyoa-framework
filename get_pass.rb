require 'io/console'
require 'watir-webdriver'

print "Email: "
myLogin = gets.chomp
print "Password (hidden): "
myPassword = STDIN.noecho(&:gets).chomp
puts 'got it'
browser = Watir::Browser.new
# puts 'Fetching your Facebook app token...'
browser.goto 'localhost:9393/server-side'
browser.text_field(:id => 'email').when_present.set myLogin
browser.text_field(:id => 'pass').when_present.set myPassword

browser.button(:name => 'login').when_present.click

# auto confirm permissions if necessary
if browser.form(:id => 'platformDialogForm').exists?
	browser.button(:name => '__CONFIRM__').click
end

if /callback\?code=/.match(browser.url)
	puts "You got the page"
	puts browser.pre.inner_html
end


# puts 'Fetching your Facebook ID...'
# fb_token = /#access_token=(.*)&expires_in/.match(browser.url).captures[0]
# puts 'My FB_TOKEN is '+fb_token

# browser.goto'https://www.facebook.com/profile.php'
# fb_id = /fbid=(.*)&set/.match(browser.link(:class =>"profilePicThumb").when_present.href).captures[0]
# puts 'My FB_ID is '+fb_id

browser.close
