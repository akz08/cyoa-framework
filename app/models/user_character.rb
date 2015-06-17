class UserCharacter < ActiveRecord::Base
	belongs_to :user
	belongs_to :character

	validates :fb_user_id, presence: true
	validates :character_id, presence: true, uniqueness: { scope: :fb_user_id }
end