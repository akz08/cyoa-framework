class MessageSceneDependency < ActiveRecord::Base
	belongs_to :message
	belongs_to :scene

	validates :message_id, presence: true
	validates :scene_id, presence: true
end