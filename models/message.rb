class Message < ActiveRecord::Base
	belongs_to :parent_choice, class_name: "Choice", foreign_key: "choice_id"
	has_many :choices, class_name: "Choice"
end