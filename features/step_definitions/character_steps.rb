Given(/^the system knows about the following characters$/) do |characters|
  characters.hashes.each do |attributes|
  	FactoryGirl.create(:character, attributes)
  end
end

When(/^the client requests a list of ([a-z]+)$/) do |type|
  get('/v0.1/' + type)
end

Then(/^the response is a list containing (#{CAPTURE_NUMBER}) characters$/) do |count|
  data = MultiJson.load(last_response.body)
  expect(data.count).to eq(count)
end

Then(/^(#{CAPTURE_NUMBER}) character has the following attributes:$/) do |count, table|
	# discard type for now
	expected_item = table.hashes.each_with_object({}) do |row, hash|
		name, value, type = row['attribute'], row['value'], row['type']
		hash[name] = value.to_type(type.constantize)
	end
	data = MultiJson.load(last_response.body)
	matched_items = data.select { |item| item == expected_item }
	expect(matched_items.count).to eq(count)
end