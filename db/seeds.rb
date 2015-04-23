require 'nokogiri'

xmlDocPath = File.expand_path("../../app/assets/app.xml", __FILE__)

doc = Nokogiri::XML(File.open(xmlDocPath)) do |config|
	config.strict.nonet
end

Character.create(name: "Amy", age: 17, gender: "Female", description: "Blah blah", default: true)