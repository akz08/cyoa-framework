require 'attr_encrypted'

class User < ActiveRecord::Base
	has_many :characters, through: :user_characters, dependent: :destroy
	has_many :messages, through: :user_messages, dependent: :destroy

	validates_presence_of :fb_user_id, :on => :create

	attr_encrypted :email, :key => ENV['ENCRYPT_KEY']

	after_create :create_characters

	private
	def create_characters
		Character.where(is_add_on: false).each do |c|
			UserCharacter.create(
				:fb_user_id => self.fb_user_id,
				:character_id => c.id
			)
		end
	end
end