class Scene < ActiveRecord::Base
	belongs_to :character
	has_many :messages, dependent: :destroy
	has_many :messages, through: :scene_dependencies, dependent: :destroy

	validates :character_id, presence: true
	validates :information, presence: true
end