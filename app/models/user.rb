require 'attr_encrypted'

require_relative './character'

class User < ActiveRecord::Base
	self.primary_key = :fb_user_id

	has_many :api_keys, foreign_key: :fb_user_id, dependent: :destroy	# Associate each user with the api_keys that they have.
	has_and_belongs_to_many :characters, foreign_key: :fb_user_id		# Associate each user with the characters that they have unlocked.
	has_and_belongs_to_many :scenes, foreign_key: :fb_user_id			# Associate each user with the scenes that they have unlocked.
	has_and_belongs_to_many :messages, foreign_key: :fb_user_id			# Associate each user with the messages that they have exchanged.

	validates :fb_user_id, presence: true

	attr_encrypted :email, key: ENV['ENCRYPT_KEY']

	after_create :unlock_default_characters

	private

	def unlock_default_characters
		Character.where(is_add_on: false).each do |c|
			self.characters << c
		end
	end
end