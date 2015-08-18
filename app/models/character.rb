class Character < ActiveRecord::Base
	has_and_belongs_to_many :users, association_foreign_key: 'fb_user_id'
	has_many :scenes, dependent: :destroy

	validates :name, presence: true
	validates :age, presence: true
	validates :gender, presence: true
	validates :description, presence: true
	validates :add_on, inclusion: { in: [true, false] }
end