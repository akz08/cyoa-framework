class ApiKey < ActiveRecord::Base
	belongs_to :user, foreign_key: 'fb_user_id'		# Associate each key with the user that it belongs to.

	validates :fb_user_id, presence: true

	before_create :generate_key

	private
	
	def generate_key
		begin
			self.key = SecureRandom.hex
		end while self.class.exists?(key: key)
	end
end