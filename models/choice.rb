class Choice < ActiveRecord::Base
	# belongs_to :parent_message, class_name: "Message", foreign_key: "message_id"
	# has_one :message, class_name: "Message", foreign_key: "choice_id"
	has_one :message, class_name: "Choice", foreign_key: "child_message_id"

	validates :parent_message_id, presence: true
	validates :child_message_id, presence: true
	validates :text, presence: true
end