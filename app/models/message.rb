class Message < ActiveRecord::Base
	belongs_to :parent, class_name: 'Message', foreign_key: 'parent_id'										# Associate each message with its parent message.
	belongs_to :scene																						# Associate each message with the scene that it belongs to.
	has_one :message_scene_dependency, class_name: 'MessageSceneDependency', dependent: :destroy			# Associate each message with its message-scene dependency.
	has_one :dependent_scene, through: :message_scene_dependency, class_name: 'Scene', source: :scene		# Associate each message with the scene that depends on it.
	has_many :children, class_name: 'Message', foreign_key: 'parent_id', dependent: :destroy				# Associate each message with its child messages.
	has_and_belongs_to_many :users, association_foreign_key: 'fb_user_id'									# Associate each message with the users that have exchanged them.

	validates :scene_id, presence: true
	validates :text, presence: true
	validates :from_character, inclusion: { in: [true, false] }
end