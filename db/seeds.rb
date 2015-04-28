require 'nokogiri'

def self.main
	# Set relative path to XML document containing the application seed data
	xmlDocPath = File.expand_path("../../app/assets/app.xml", __FILE__)
	# Read specified XML document using Nokogiri
	doc = Nokogiri::XML(File.open(xmlDocPath)) do |config|
		config.strict.nonet.noblanks
	end
	# Create character, scene and message records
	character_node_set = doc.xpath("//character")
	for node in character_node_set do
		character = create_character(node)
		scene_node_set = node.xpath("scene")
		for node in scene_node_set do
			scene = create_scene(node, character.id)
			create_messages(node.first_element_child, scene.id, nil)
		end
	end
end

# Create a single character record from its XML
# Params:
# +character_xml+:: Nokogiri element node containing character information
def self.create_character(character_xml)
	# Get information from XML node
	name = character_xml.xpath("@name")
	age = character_xml.xpath("@age").to_s.to_i
	gender = character_xml.xpath("@gender")
	description = character_xml.xpath("@description")
	is_add_on = character_xml.xpath("@is_add_on")
	if !is_add_on.empty? then (is_add_on = !is_add_on.to_s.to_i.zero?) else (is_add_on = false) end
	# Create and return character record
	character = Character.create(name: name, age: age, gender: gender, description: description, is_add_on: is_add_on)
	return character
end

# Create a single scene record from its XML
# Params:
# +scene_xml+:: Nokogiri element node containing scene information
# +character_id+:: id of containing character record
def self.create_scene(scene_xml, character_id)
	# Get information from XML node
	information = scene_xml.xpath("@information")
	# Create and return scene record
	scene = Scene.create(character_id: character_id, information: information)
	return scene
end

# Use pre-order depth-first search to sequentially create message records from a scene
# Params:
# +message_xml+:: Nokogiri element node containing message information
# +scene_id+:: id of containing scene record
# +parent_id+:: id of parent message record
def self.create_messages(message_xml, scene_id, parent_id)
	# Create record for the current message
	message = create_message(message_xml, scene_id, parent_id)
	# Recurse on all children, if any
	children = message_xml.children
	if !children.empty? then
		parent_id = message.id
		for child in children do
			create_messages(child, scene_id, parent_id)
		end
	end
end

# Create a single message record from its XML
# Params:
# +message_xml+:: Nokogiri element node containing message information
# +scene_id+:: id of containing scene record
# +parent_id+:: id of parent message
def self.create_message(message_xml, scene_id, parent_id)
	# Get information from XML node
	text = message_xml.xpath("@text")
	is_incoming = message_xml.name == "message_in"
	delay = message_xml.xpath("@delay")
	if !delay.empty? then (delay = delay.to_s.to_i) else (delay = nil) end
	# Create and return message record
	message = Message.create(scene_id: scene_id, text: text, is_incoming: is_incoming, delay: delay, parent_id: parent_id)
	return message
end

main