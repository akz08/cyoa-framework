class Character < ActiveRecord::Base
	has_many :scenes
	has_many :user_characters

	validates :name, presence: true
	validates :age, presence: true
	validates :gender, presence: true
	validates :description, presence: true
	validates :default, presence: true
end