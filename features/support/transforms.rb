CAPTURE_NUMBER = Transform /^\d+$/ do |number|
	number.to_i
end