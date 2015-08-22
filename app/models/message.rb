class Message < ActiveRecord::Base
	has_and_belongs_to_many :users, association_foreign_key: 'fb_user_id'
	belongs_to :scene
	# Each message can have a single scene that is dependent on it.
	has_one :message_scene_dependency, dependent: :destroy
	has_one :dependent_scene, through: :message_scene_dependency, source: :scene
	# Each message has a single parent, and many children.
	belongs_to :parent, class_name: 'Message', foreign_key: 'parent_id'
	has_many :children, class_name: 'Message', foreign_key: 'parent_id', dependent: :destroy

	validates :scene_id, presence: true
	validates :text, presence: true
	validates :from_character, inclusion: { in: [true, false] }
end