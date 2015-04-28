class Character < ActiveRecord::Base
	has_many :scenes, dependent: :destroy
	has_many :users, through: :user_characters, dependent: :destroy

	validates :name, presence: true
	validates :age, presence: true
	validates :gender, presence: true
	validates :description, presence: true
end