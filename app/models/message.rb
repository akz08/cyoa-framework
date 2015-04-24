class Message < ActiveRecord::Base
	belongs_to :scene
	has_one :parent, class_name: "Message", foreign_key: "parent_id"
	has_many :responses, class_name: "Message", foreign_key: "parent_id", dependent: :destroy
	has_many :user_messages, dependent: :destroy

	validates :scene_id, presence: true
	validates :text, presence: true
	validates :from_self, exclusion: { in: [nil] }
end