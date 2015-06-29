class Scene < ActiveRecord::Base
	belongs_to :character																								# Associate each scene with the character that it belongs to.
	has_many :messages, dependent: :destroy																				# Associate each scene with the messages that it has.
	has_many :message_scene_dependencies, class_name: 'MessageSceneDependency', dependent: :destroy						# Associate each scene with its message-scene dependencies.
	has_many :message_dependencies, through: :message_scene_dependencies, class_name: 'Message', source: :message		# Associate each scene with its message dependencies.
	has_and_belongs_to_many :users, association_foreign_key: 'fb_user_id'												# Associate each scene with the users that have unlocked it.

	validates :character_id, presence: true
	validates :information, presence: true
end