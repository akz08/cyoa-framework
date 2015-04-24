require 'nokogiri'

# Set relative path to XML document containing the application seed data
xmlDocPath = File.expand_path("../../app/assets/app.xml", __FILE__)

# Read specified XML document using Nokogiri
doc = Nokogiri::XML(File.open(xmlDocPath)) do |config|
	config.strict.nonet
end

character_node_set = doc.xpath("//character")

for node in character_node_set do
	# Create character record
	name = node.xpath("@name")
	age = node.xpath("@age").to_s.to_i
	gender = node.xpath("@gender")
	description = node.xpath("@description")
	add_on = node.xpath("@add_on")
	if !add_on.empty? then (add_on = !add_on.to_s.to_i.zero?) else (add_on = false) end
	
	character = Character.create(name: name, age: age, gender: gender, description: description, add_on: add_on)
	character_id = character.id

	scene_node_set = node.xpath("//scene")

	for node in scene_node_set do
		# Create scene record
		information = node.xpath("@information")
	
		scene = Scene.create(character_id: character_id, information: information)
		scene_id = scene.id

		message_node_set = node.xpath("//message | //response")

		parent_id = nil

		for node in message_node_set do
			# Create message record
			text = node.xpath("@text")
			from_self = node.name == "message"
			delay = node.xpath("@delay")
			if !delay.empty? then (delay = delay.to_s.to_i) else (delay = nil) end

			message = Message.create(scene_id: scene_id, text: text, from_self: from_self, parent_id: parent_id, delay: delay)
			parent_id = message.id
		end
	end
end