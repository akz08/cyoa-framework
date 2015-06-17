class UserMessage < ActiveRecord::Base
	belongs_to :user
	belongs_to :message

	validates :fb_user_id, presence: true
	validates :message_id, presence: true, uniqueness: { scope: :fb_user_id }
end