Given(/^the system knows about the following characters$/) do |characters|
  # table is a Cucumber::Ast::Table
  # @characters = characters.hashes
  pending # express the regexp above with the code you wish you had
end

When(/^the client requests a list of ([a-z]+)$/) do |type|
	puts type
	pending
end

Then(/^the response is a list containing (\d+) characters$/) do |count|
  pending # express the regexp above with the code you wish you had
end

Then(/^one character has the following attributes:$/) do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end