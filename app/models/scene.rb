class Scene < ActiveRecord::Base
	belongs_to :character													# Associate each scene with the character that it belongs to.
	has_many :messages, dependent: :destroy									# Associate each scene with the messages that it has.
	has_and_belongs_to_many :dependencies, class_name: 'Message'			# Associate each scene with the messages that it is dependent on.
	has_and_belongs_to_many :users, association_foreign_key: 'fb_user_id'	# Associate each scene with the users that have unlocked it.

	validates :character_id, presence: true
	validates :information, presence: true
end