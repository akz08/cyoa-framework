class UserMessage < ActiveRecord::Base
	belongs_to :user
	belongs_to :message

	validates :user_id, presence: true
	validates :message_id, presence: true, uniqueness: { scope: :user_id }
end