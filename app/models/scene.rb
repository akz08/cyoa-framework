class Scene < ActiveRecord::Base
	has_and_belongs_to_many :users, association_foreign_key: 'fb_user_id'
	belongs_to :character
	has_many :messages, dependent: :destroy
	# Each scene has many messages upon which it can be dependent.
	has_many :message_scene_dependencies, class_name: 'MessageSceneDependency', dependent: :destroy
	has_many :message_dependencies, through: :message_scene_dependencies, class_name: 'Message', source: :message

	validates :character_id, presence: true
	validates :information, presence: true
end