class SceneDependency < ActiveRecord::Base
	belongs_to :scene
	belongs_to :message

	validates :scene_id, presence: true
	validates :message_id, presence: true, uniqueness: { scope: :scene_id }
end