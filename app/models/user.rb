require 'attr_encrypted'

class User < ActiveRecord::Base
	self.primary_key = :fb_user_id

	has_and_belongs_to_many :characters		# Associate each user with the characters that they have unlocked.
	has_and_belongs_to_many :messages		# Associate each user with the messages that they have exchanged.

	validates :fb_user_id, presence: true

	attr_encrypted :email, :key => ENV['ENCRYPT_KEY']
end