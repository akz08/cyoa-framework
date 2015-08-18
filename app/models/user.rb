require 'attr_encrypted'

require_relative './character'
require_relative './message'
require_relative './scene'

class User < ActiveRecord::Base
	self.primary_key = 'fb_user_id'

	has_many :api_keys, foreign_key: 'fb_user_id', dependent: :destroy
	has_and_belongs_to_many :characters, foreign_key: 'fb_user_id'
	has_and_belongs_to_many :scenes, foreign_key: 'fb_user_id'
	has_and_belongs_to_many :messages, foreign_key: 'fb_user_id'

	validates :fb_user_id, presence: true

	attr_encrypted :email, key: ENV['ENCRYPT_KEY']

	after_create :create_associations

	private

	def create_associations
		ApiKey.create(fb_user_id: self.fb_user_id)
		Character.where(add_on: false).each do |character|
			self.characters << character
			scene = character.scenes.first
			self.scenes << scene
			message = scene.messages.first
			self.messages << message
		end
	end
end