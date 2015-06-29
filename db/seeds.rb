require 'nokogiri'

require_relative '../app/models/character'
require_relative '../app/models/message'
require_relative '../app/models/scene'

def self.main
	# Set relative path to XML document containing application seed data
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
			scene = create_scene(character.id, node)
			create_messages_in_scene(scene.id, node.first_element_child, nil)
			create_scene_dependencies(scene, node)
		end
	end
end

# Create a single character record from its XML
# Params:
# +xml+:: Nokogiri element node containing character information
def self.create_character(xml)
	name = xml.xpath("@name").to_s
	age = xml.xpath("@age").to_s.to_i
	gender = xml.xpath("@gender").to_s
	description = xml.xpath("@description").to_s
	add_on = xml.xpath("@add_on")
	if !add_on.empty? then (add_on = !add_on.to_s.to_i.zero?) else (add_on = false) end
	Character.create(name: name, age: age, gender: gender, description: description, add_on: add_on)
end

# Create a single scene record from its XML
# Params:
# +character_id+:: id of containing character record
# +xml+:: Nokogiri element node containing scene information
def self.create_scene(character_id, xml)
	information = xml.xpath("@information").to_s
	Scene.create(character_id: character_id, information: information)
end

# Use pre-order depth-first search to sequentially create message records from a scene
# Params:
# +scene_id+:: id of containing scene record
# +xml+:: Nokogiri element node containing scene message tree's root message information
# +parent_id+:: id of parent message record
def self.create_messages_in_scene(scene_id, xml, parent_id)
	# Create record for current message
	message = create_message(scene_id, xml, parent_id)
	# Recurse on all children, if any
	children = xml.children
	if !children.empty? then
		parent_id = message.id
		for child_xml in children do
			create_messages_in_scene(scene_id, child_xml, parent_id)
		end
	end
end

# Create a single message record from its XML
# Params:
# +scene_id+:: id of containing scene record
# +xml+:: Nokogiri element node containing message information
# +parent_id+:: id of parent message
def self.create_message(scene_id, xml, parent_id)
	text = xml.xpath("@text").to_s
	from_character = xml.name.to_s == "character_message"
	Message.create(scene_id: scene_id, text: text, from_character: from_character, parent_id: parent_id)
end

# Create records for the dependencies that a scene has on messages
# Params:
# +scene+:: Scene object to establish dependencies for
# +xml+:: Nokogiri element node containing scene information
def self.create_scene_dependencies(scene, xml)
	dependencies = xml.xpath("@parent_messages").to_s.delete(" ").split(",").each do |dependency|
		# Get id of message record upon which scene is dependent
		depends_on_scene_xml_id = dependency.split(":")[0].to_i
		depends_on_scene = Scene.where("character_id = #{scene.character_id}")[depends_on_scene_xml_id - 1]
		depends_on_message_xml_id = dependency.split(":")[1].to_i
		depends_on_message = Message.where("scene_id = #{depends_on_scene.id}")[depends_on_message_xml_id - 1]
		# Create specified dependency record
		scene.dependencies << depends_on_message
	end
end

main

if ENV['RACK_ENV'] == 'development'
	require_relative '../app/models/user'

	user = User.create(fb_user_id: 0, first_name: "Hal", last_name: "Emmerich", email: "hal.emmerich@philanthropy.com")
	user.scenes << Scene.find(2)
	user.messages << Message.find(2)
	user.messages << Message.find(4)
	user.messages << Message.find(6)

	User.create(fb_user_id: 1, first_name: "David", last_name: "Pliskin", email: "david.pliskin@philanthropy.com")
end