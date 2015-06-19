class Scene < ActiveRecord::Base
	belongs_to :character						# Associate each scene with the character that it belongs to.
	has_many :messages, dependent: :destroy		# Associate each scene with the messages that it has.
	has_and_belongs_to_many :messages			# Associate each scene with the messages that it is dependent on.

	validates :character_id, presence: true
	validates :information, presence: true
end