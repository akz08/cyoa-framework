class Message < ActiveRecord::Base
	belongs_to :scene
	belongs_to :parent, class_name: "Message", foreign_key: "parent_id"
	has_many :children, class_name: "Message", foreign_key: "parent_id", dependent: :destroy
	has_many :users, through: :user_messages, dependent: :destroy

	validates :scene_id, presence: true
	validates :text, presence: true
	validates :is_incoming, exclusion: { in: [nil] }
end