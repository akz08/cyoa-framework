class Character < ActiveRecord::Base
	has_many :scenes, dependent: :destroy	# Associate each character with the scenes that it has.
	has_and_belongs_to_many :users			# Associate each character with the users that have unlocked them.

	validates :name, presence: true
	validates :age, presence: true
	validates :gender, presence: true
	validates :description, presence: true
	validates :is_add_on, :inclusion => { :in => [true, false] }
end