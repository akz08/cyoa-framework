class MessageSceneDependency < ActiveRecord::Base
	belongs_to :message		# Associate each message-scene dependency with the message that it belongs to.
	belongs_to :scene		# Associate each message-scene dependency with the scene that it belongs to.

	validates :message_id, presence: true
	validates :scene_id, presence: true
end