class Message < ActiveRecord::Base
	belongs_to :parent, class_name: 'Message', foreign_key: 'parent_id'							# Associate each message with its parent message.
	belongs_to :scene																			# Associate each message with the scene that it belongs to.
	has_many :children, class_name: 'Message', foreign_key: 'parent_id', dependent: :destroy	# Associate each message with its child messages.
	has_and_belongs_to_many :dependent_scenes, class_name: 'Scene'								# Associate each message with the scenes that depend on it.
	has_and_belongs_to_many :users, association_foreign_key: 'fb_user_id'						# Associate each message with the users that have exchanged them.

	validates :scene_id, presence: true
	validates :text, presence: true
	validates :is_incoming, inclusion: { in: [true, false] }
end