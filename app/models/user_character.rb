class UserCharacter < ActiveRecord::Base
	belongs_to :user
	belongs_to :character

	validates :user_id, presence: true
	validates :character_id, presence: true, uniqueness: { scope: :user_id }
end