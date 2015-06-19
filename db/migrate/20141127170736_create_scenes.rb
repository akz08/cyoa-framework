class CreateScenes < ActiveRecord::Migration
	def change
		create_table :scenes do |t|
			t.belongs_to :character, index: true
			t.text :information, null: false
		end
	end
end