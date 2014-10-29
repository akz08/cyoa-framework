require 'io/console'
require 'watir-webdriver'

print "Email: "
myLogin = gets.chomp
print "Password (hidden): "
myPassword = STDIN.noecho(&:gets).chomp
puts 'got it'
browser = Watir::Browser.new
# puts 'Fetching your Facebook Tinder token...'
browser.goto 'https://www.facebook.com/dialog/oauth?client_id=464891386855067&redirect_uri=https://www.facebook.com/connect/login_success.html&scope=basic_info,email,public_profile,user_about_me,user_activities,user_birthday,user_education_history,user_friends,user_interests,user_likes,user_location,user_photos,user_relationship_details&response_type=token'
browser.text_field(:id => 'email').when_present.set myLogin
browser.text_field(:id => 'pass').when_present.set myPassword
browser.button(:name => 'login').when_present.click

puts 'Fetching your Facebook ID...'
fb_token = /#access_token=(.*)&expires_in/.match(browser.url).captures[0]
puts 'My FB_TOKEN is '+fb_token

browser.goto'https://www.facebook.com/profile.php'
fb_id = /fbid=(.*)&set/.match(browser.link(:class =>"profilePicThumb").when_present.href).captures[0]
puts 'My FB_ID is '+fb_id

browser.close
