class Message < ActiveRecord::Base
	belongs_to :scene
	# belongs_to :parent_choice, class_name: "Choice", foreign_key: "choice_id"
	has_many :choices, class_name: "Choice", foreign_key: "parent_message_id"

	validates :scene_id, presence: true
	validates :text, presence: true
end