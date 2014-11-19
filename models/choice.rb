class Choice < ActiveRecord::Base
	belongs_to :parent_message, class_name: "Message", foreign_key: "message_id"
	has_one :message, class_name: "Message", foreign_key: "choice_id"
end